# == Schema Information
#
# Table name: installments
#
#  id                          :bigint           not null, primary key
#  number                      :string
#  value_cents                 :bigint           default(0), not null
#  value_currency              :string           default("BRL"), not null
#  initial_fator_cents         :bigint           default(0), not null
#  initial_fator_currency      :string           default("BRL"), not null
#  initial_advalorem_cents     :bigint           default(0), not null
#  initial_advalorem_currency  :string           default("BRL"), not null
#  initial_protection_cents    :bigint           default(0), not null
#  initial_protection_currency :string           default("BRL"), not null
#  due_date                    :date
#  ordered_at                  :datetime
#  deposited_at                :datetime
#  finished_at                 :datetime
#  backoffice_status           :integer          default("backoffice_status_not_set")
#  liquidation_status          :integer          default("liquidation_status_not_set")
#  unavailability              :integer          default("unavailability_not_set")
#  rejection_motive            :integer          default("rejection_motive_not_set")
#  import_ref                  :string
#  invoice_id                  :bigint
#  operation_id                :bigint
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  final_fator_cents           :bigint           default(0), not null
#  final_fator_currency        :string           default("BRL"), not null
#  final_advalorem_cents       :bigint           default(0), not null
#  final_advalorem_currency    :string           default("BRL"), not null
#  final_protection_cents      :bigint           default(0), not null
#  final_protection_currency   :string           default("BRL"), not null
#  veredict_at                 :datetime
#

class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :operation, optional: true
  has_and_belongs_to_many :billing_ruler, optional: true
  has_one :balance, dependent: :destroy
  monetize :value_cents, with_model_currency: :currency
  monetize :initial_fator_cents, with_model_currency: :currency
  monetize :initial_advalorem_cents, with_model_currency: :currency
  monetize :initial_protection_cents, with_model_currency: :currency
  monetize :final_fator_cents, with_model_currency: :currency
  monetize :final_advalorem_cents, with_model_currency: :currency
  monetize :final_protection_cents, with_model_currency: :currency
  #Changes the net_value representation
  monetize :corrected_net_value_cents, with_model_currency: :currency

  after_destroy :destroy_parent_if_void
  after_save :async_update_spreadsheet

  # Helper for other scopes
  scope :from_seller,                -> (seller) { joins(:invoice).where(invoices: {seller: seller}) }

  # For the dashboard
  scope :used_limit,                 -> (seller) { from_seller(seller).merge(ordered.or(approved).or(deposited.opened)) }
  scope :in_analysis,                -> (seller) { from_seller(seller).merge(ordered) }
  scope :liquidation_expected_today, -> (seller) { from_seller(seller).merge(opened.where(due_date: (Date.current - 3.days))) }
  scope :liquidation_expected_week,  -> (seller) { from_seller(seller).merge(opened.where("due_date > :today AND due_date <= :end_week", {today: (Date.current - 3.days), end_week: (Date.current - 3.days).end_of_week})) }
  scope :liquidation_expected_month, -> (seller) { from_seller(seller).merge(opened.where("due_date > :end_week AND due_date <= :end_month", {end_week: (Date.current - 3.days).end_of_week, end_month: (Date.current - 3.days).end_of_month})) }
  scope :overdue,                    -> (seller) { from_seller(seller).merge(opened.where("due_date < :today", {today: (Date.current - 3.days)})) }
  scope :overdue_upto_7,             -> (seller) { from_seller(seller).merge(opened.where("due_date >= :seven_days_ago AND due_date < :today", {today: (Date.current - 3.days), seven_days_ago: (7.days.ago.to_date - 3.days)})) }
  scope :overdue_upto_30,            -> (seller) { from_seller(seller).merge(opened.where("due_date >= :thirty_days_ago AND due_date <= :seven_days_ago", {seven_days_ago: (7.days.ago.to_date - 3.days), thirty_days_ago:  (30.days.ago.to_date - 3.days)})) }
  scope :overdue_30_plus,            -> (seller) { from_seller(seller).merge(opened.where("due_date < :thirty_days_ago", {thirty_days_ago:  (30.days.ago.to_date - 3.days)})) }
  # scope settled is note used anywhere right now
  scope :settled,                    -> (seller) { from_seller(seller).merge(paid.or(pdd)) }
  scope :total,                      -> (scope, seller) { Money.new(__send__(scope, seller).sum(:value_cents)) }
  scope :quant,                      -> (scope, seller) { __send__(scope, seller).count }

  # For the tables of cards
  scope :in_store,                   -> (seller) { from_seller(seller).merge(unavailable.or(available)).preload(invoice: [:payer]).order('due_date ASC') }
  scope :currently_opened,           -> (seller) { from_seller(seller).merge(deposited.opened).preload(invoice: [:payer]).order('due_date ASC') }
  scope :finished,                   -> (seller) { from_seller(seller).merge(deposited.merge(paid.or(pdd))).preload(invoice: [:payer]).order('finished_at DESC') }

  # For creating operations
  scope :ordered_in_analysis,        -> (seller) { from_seller(seller).merge(ordered).preload(invoice: [:payer]) }
  include Trackable

# Any change in this enum must be reflected on the sql querry in Invoice Model
  enum liquidation_status: {
    liquidation_status_not_set: 0,
    opened:                     1,
    paid:                       2,
    pdd:                        3,
  }

  #TODO implement event sourcing
  enum backoffice_status: {
    backoffice_status_not_set: 0,
    unavailable:               1,
    available:                 2,
    approved:                  3,
    rejected:                  4,
    rejected_consent:          5,
    cancelled:                 6,
    ordered:                   7,
    deposited:                 8,
  }

  enum unavailability: {
    unavailability_not_set:        0,
    unavailability_non_applicable: 1,
    due_date_past:                 2,
    due_date_later_than_limit:     3,
    already_operated:              4,
  }

  enum rejection_motive: {
    rejection_motive_not_set:        0,
    rejection_motive_non_applicable: 1,
    fake:                            2,
    payer_low_rated:                 3,
  }

  # Because of the delay of liquidation of boletos we always consider that we will receive the money 3 days after the due_date
  def expected_liquidation_date
    due_date + 3.days
  end

  # This method and the method status are used to display the current status of the installment in the view.
  def statuses
    {
      available: "Disponível",
      ordered: "Em análise",
      approved: "Aprovada",
      rejected_aux: "Rejeitada",
      cancelled: "Cancelada",
      on_date: "A vencer",
      due_today: "Vence hoje",
      waiting_liquidation: "Aguardando liquidação",
      expected_liquidation_today: "Liquidação esperada",
      overdue: "Em atraso",
      paid: "Liquidada",
      pdd: "Perdida",
    }
  end

  def analysis_requested?
    ordered_at.present?
  end

  def analysis_completed?
    veredict_at.present?
  end

  def rejected_aux?
    rejected? || rejected_consent?
  end

  def operation_started?
    deposited_at.present?
  end

  def on_date?
    opened? && due_date > Date.current
  end

  def due_today?
    opened? && due_date == Date.current
  end

  def waiting_liquidation?
    opened? && due_date < Date.current && expected_liquidation_date > Date.current
  end

  def expected_liquidation_today?
    opened? && expected_liquidation_date == Date.current
  end

  # The concept of overdue is not related to when the installment is due, but when it is expected to be liquidated
  def overdue?
    opened? && expected_liquidation_date < Date.current
  end

  def ahead?
    opened? && due_date > Date.current
  end

  def operation_ended?
    finished_at.present?
  end

  def operation_ended_overdue?
    if operation_ended?
      finished_at.to_date > expected_liquidation_date
    else
      false
    end
  end

  def operation_ended_ahead?
    if operation_ended?
      finished_at.to_date < due_date
    else
      false
    end
  end

  def elapsed_days
    (Date.current - ordered_at.to_date).to_i
  end

  def initial_operation_days
    (expected_liquidation_date - ordered_at.to_date).to_i
  end

  # Days until the due_date
  def outstanding_days
    if overdue? || operation_ended? || waiting_liquidation? || expected_liquidation_today?
      0
    elsif analysis_requested? && !analysis_completed?
      (due_date - ordered_at.to_date).to_i
    elsif due_date_past? || already_operated?
      0
    else
      (due_date - Date.current).to_i
    end
  end

  # Days until expected_liquidation_date
  def outstanding_days_to_liquidation
    if overdue? || operation_ended?
      0
    elsif analysis_requested? && !analysis_completed?
      (expected_liquidation_date - ordered_at.to_date).to_i
    elsif due_date_past? || already_operated?
      0
    else
      (expected_liquidation_date - Date.current).to_i
    end
  end

  def ended_operation_total_days
    if operation_ended?
      (finished_at.to_date - ordered_at.to_date).to_i
    else
      0
    end
  end

  def overdue_days
    if overdue?
      (Date.current - expected_liquidation_date).to_i
    elsif operation_ended_overdue?
      (finished_at.to_date - expected_liquidation_date).to_i
    else
      0
    end
  end

  # TODO change the name to fator_absolute
  def fator
    if operation_ended?
      final_fator
    elsif analysis_completed?
      if overdue? || ahead?
        value * (1 - 1/(1 + invoice.fator)**((elapsed_days) / 30.0))
      else
        initial_fator
      end
    else
      value * (1 - 1/(1 + invoice.fator)**((outstanding_days_to_liquidation) / 30.0))
    end
  end

  def delta_fator
    if overdue? || ahead?
      initial_fator - (value * (1 - 1/(1 + invoice.fator)**((elapsed_days) / 30.0)))
    elsif opened?
      Money.new(0)
    else
      initial_fator - final_fator
    end
  end

  def advalorem
    if operation_ended?
      final_advalorem
    elsif analysis_completed?
      if overdue? || ahead?
        value * (1 - 1/(1 + invoice.advalorem)**((elapsed_days) / 30.0))
      else
        initial_advalorem
      end
    else
      value * (1 - 1/(1 + invoice.advalorem)**((outstanding_days_to_liquidation) / 30.0))
    end
  end

  def delta_advalorem
    if overdue? || ahead?
      initial_advalorem - (value * (1 - 1/(1 + invoice.advalorem)**((elapsed_days) / 30.0)))
    elsif opened?
      Money.new(0)
    else
      initial_advalorem - final_advalorem
    end
  end

  def fee
    fator + advalorem
  end

  def initial_fee
    initial_fator + initial_advalorem
  end

  def delta_fee
    if renegotiation
      renegotiation_delta_fee
    else
      delta_fator + delta_advalorem
    end
  end

  def renegotiation_delta_fee
    new_fator = value * (1 - 1/(1 + invoice.fator)**((operation_length) / 30.0))
    new_advalorem = value * (1 - 1/(1 + invoice.advalorem)**((operation_length) / 30.0))
    new_delta_fator = new_fator - (value * (1 - 1/(1 + invoice.fator)**((elapsed_days) / 30.0)))
    new_delta_advalorem = new_advalorem - (value * (1 - 1/(1 + invoice.advalorem)**((elapsed_days) / 30.0)))
    new_delta_fator + new_delta_advalorem
  end

  def net_value
    value - fee
  end

  def initial_net_value
    return Money.new(corrected_net_value_cents) unless corrected_net_value_cents.nil? || corrected_net_value_cents&.zero?

    value - initial_fee
  end

  def protection
    if operation_ended?
      final_protection
    elsif analysis_completed?
      if overdue?
        initial_protection - delta_fee
      else
        initial_protection
      end
    else
      value * invoice.protection_rate
    end
  end

  def first_deposit_amount
      net_value - protection
  end

  def installment_attributes
    {
      seller_name: self.invoice.seller.company_name,
      seller_id: self.invoice.seller_id.to_s,
      seller_cnpj: self.invoice.seller.cnpj,
      operation_id: self.operation_id.to_s,
      invoice_id: self.invoice_id.to_s,
      payer_name: self.invoice.payer.company_name,
      payer_id: self.invoice.payer_id.to_s,
      payer_cnpj: self.invoice.payer.cnpj,
      id: self.id.to_s,
      status: self.status[1],
      invoice_number: self.invoice.number,
      number: self.number,
      value_cents: self.value_cents,
      value_currency: self.value_currency,
      initial_fator_cents: self.initial_fator_cents,
      initial_fator_currency: self.initial_fator_currency,
      initial_advalorem_cents: self.initial_advalorem_cents,
      initial_advalorem_currency: self.initial_advalorem_currency,
      initial_protection_cents: self.initial_protection_cents,
      initial_protection_currency: self.initial_protection_currency,
      final_fator_cents: self.final_fator_cents,
      final_fator_currency: self.final_fator_currency,
      final_advalorem_cents: self.final_advalorem_cents,
      final_advalorem_currency: self.final_advalorem_currency,
      final_protection_cents: self.final_protection_cents,
      final_protection_currency: self.final_protection_currency,
      due_date: self.due_date&.strftime,
      ordered_at: self.ordered_at&.to_s,
      veredict_at: self.veredict_at&.to_s,
      deposited_at: self.deposited_at&.to_s,
      finished_at: self.finished_at&.to_s,
      backoffice_status: self.backoffice_status,
      liquidation_status: self.liquidation_status,
      unavailability: self.unavailability,
      rejection_motive: self.rejection_motive,
    }.stringify_keys
  end

  def async_update_spreadsheet
    SpreadsheetsRowSetterJob.perform_later(spreadsheet_id, worksheet_name, (self.id + 1), self.installment_attributes)
  end

  def spreadsheet_id
    ENV['GOOGLE_SPREADSHEET_ID']
  end

  def worksheet_name
    Rails.application.credentials[:google][:google_installment_worksheet_name]
  end

  def notify_seller(seller)
    user = seller.users.first
    if operation_ended_overdue?
      InstallmentMailer.paid_overdue(self, user, seller).deliver_now
    elsif operation_ended_ahead?
      InstallmentMailer.paid_ahead(self, user, seller).deliver_now
    else
      InstallmentMailer.paid(self, user, seller).deliver_now
    end
  end

  def operation_length
    (expected_liquidation_date - created_at&.to_date).to_i
  end

  def due_date_format
    due_date.strftime("%d/%m/%Y") unless due_date.nil?
  end

  def invoice_number
    invoice.number unless invoice.nil?
  end

  def invoice_payer_name
    invoice.payer_name unless invoice.nil?
  end

  def invoice_payer_cnpj
    invoice.payer_cnpj unless invoice.nil?
  end

  private

  def destroy_parent_if_void
    invoice.destroy if invoice&.installments&.count == 0
  end
end
