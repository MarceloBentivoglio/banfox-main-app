class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :operation, optional: true
  monetize :value_cents, with_model_currency: :currency
  monetize :final_net_value_cents, with_model_currency: :currency
  monetize :final_fator_cents, with_model_currency: :currency
  monetize :final_advalorem_cents, with_model_currency: :currency
  monetize :final_protection_cents, with_model_currency: :currency

  after_destroy :destroy_parent_if_void
  after_save :async_update_spreadsheet

  # Helper for other scopes
  scope :from_seller,         -> (seller) { joins(:invoice).where(invoices: {seller: seller}) }

  # For the dashboard
  scope :used_limit,          -> (seller) { from_seller(seller).merge(ordered.or(deposited.opened)) }
  scope :in_analysis,         -> (seller) { from_seller(seller).merge(ordered) }
  scope :opened_today,        -> (seller) { from_seller(seller).merge(opened.where(due_date: Date.current)) }
  scope :opened_week,         -> (seller) { from_seller(seller).merge(opened.where("due_date > :today AND due_date <= :end_week", {today: Date.current, end_week: Date.current.end_of_week})) }
  scope :opened_month,        -> (seller) { from_seller(seller).merge(opened.where("due_date > :end_week AND due_date <= :end_month", {end_week: Date.current.end_of_week, end_month: Date.current.end_of_month})) }
  scope :overdue,             -> (seller) { from_seller(seller).merge(opened.where("due_date < :today", {today: Date.current})) }
  scope :overdue_upto_7,      -> (seller) { from_seller(seller).merge(opened.where("due_date >= :seven_days_ago AND due_date < :today", {today: Date.current, seven_days_ago: 7.days.ago.to_date})) }
  scope :overdue_upto_30,     -> (seller) { from_seller(seller).merge(opened.where("due_date >= :thirty_days_ago AND due_date <= :seven_days_ago", {seven_days_ago: 7.days.ago.to_date, thirty_days_ago: 30.days.ago.to_date})) }
  scope :overdue_30_plus,     -> (seller) { from_seller(seller).merge(opened.where("due_date < :thirty_days_ago", {thirty_days_ago: 30.days.ago.to_date})) }
  scope :settled,             -> (seller) { from_seller(seller).merge(paid.or(pdd)) }
  scope :total,               -> (scope, seller) { Money.new(__send__(scope, seller).sum(:value_cents)) }
  scope :quant,               -> (scope, seller) { __send__(scope, seller).count }

  # For the tables of cards
  scope :in_store,            -> (seller) { from_seller(seller).merge(unavailable.or(available)).preload(invoice: [:payer]) }
  scope :currently_opened,    -> (seller) { from_seller(seller).merge(deposited.opened).preload(invoice: [:payer]) }
  scope :finished,            -> (seller) { from_seller(seller).merge(deposited.merge(paid.or(pdd))).preload(invoice: [:payer]) }

  # For creating operations
  scope :ordered_in_analysis, -> (seller) { from_seller(seller).merge(ordered).preload(invoice: [:payer]) }
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

  def statuses
    {
      ordered: "Em análise",
      approved: "Aprovada",
      rejected_aux: "Rejeitada",
      cancelled: "Cancelada",
      on_date: "A vencer",
      due_today: "Vence hoje",
      overdue: "Em atraso",
      paid: "Liquidada",
      pdd: "Perdida",
      available: "Disponível",
    }
  end

  def rejected_aux?
    rejected? || rejected_consent?
  end

  def overdue?
    opened? && due_date < Date.current
  end

  def on_date?
    opened? && due_date > Date.current
  end

  def due_today?
    opened? && due_date == Date.current
  end

  # Is the same of final price set but considering de the rejected. Erase after treating the rejections.
  # def analysed?
  #   approved? || rejected? || rejected_consent? || deposited? || cancelled?
  # end

  def final_price_set?
    approved? || deposited?
  end

  def outstanding_days
    if on_date?
      return (due_date - Date.current).to_i
    elsif overdue?
      return 0
    else
      days = (due_date - (ordered_at.try(:to_date) || Date.current)).to_i
      return days.positive? ? days : 0
    end
  end

  def overdue_days
    days = (Date.current - due_date).to_i
    return days.positive? ? days : 0
  end

  def operation_total_days
    (Date.current - ordered_at.to_date).to_i
  end

  # TODO change the name to fator_absolute
  def fator
    if overdue?
      final_fator + delta_fator
    else
      final_price_set? ? final_fator : value * (1 - 1/(1 + invoice.fator)**((outstanding_days + 3) / 30.0))
    end
  end

  def delta_fator
    value * (1 - 1/(1 + invoice.fator)**((operation_total_days + 3) / 30.0)) - final_fator
  end

  def advalorem
    if overdue?
      final_advalorem + delta_advalorem
    else
      final_price_set? ? final_advalorem : value * (1 - 1/(1 + invoice.advalorem)**((outstanding_days + 3) / 30.0))
    end
  end

  def delta_advalorem
    value * (1 - 1/(1 + invoice.advalorem)**((operation_total_days + 3) / 30.0)) - final_advalorem
  end

  def fee
    fator + advalorem
  end

  def final_fee
    final_fator + final_advalorem
  end


  def delta_fee
    delta_fator + delta_advalorem
  end

  def net_value
    if overdue?
      final_net_value - delta_fee
    else
      final_price_set? ? final_net_value : (value - fee)
    end
  end

  def protection
    if overdue?
      final_protection - delta_fee
    else
      final_price_set? ? final_protection : value * invoice.protection_rate
    end
  end

  def first_deposit_amount
    if overdue?
      final_net_value - final_protection
    else
      net_value - protection
    end
  end

  def installment_attributes
    {
      seller_name: self.invoice.seller.company_name,
      seller_id: self.invoice.seller_id,
      operation_id: self.operation_id,
      invoice_id: self.invoice_id,
      payer_name: self.invoice.payer.company_name,
      payer_id: self.invoice.payer_id,
      payer_cnpj: self.invoice.payer.cnpj,
      id: self.id,
      status: self.status[1],
      number: self.number,
      value_cents: self.value_cents,
      value_currency: self.value_currency,
      due_date: self.due_date.try(:strftime),
      ordered_at: self.ordered_at.try(:to_s),
      deposited_at: self.deposited_at.try(:to_s),
      received_at: self.received_at.try(:to_s),
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
    Rails.application.credentials[Rails.env.to_sym][:google_spreadsheet_id]
  end

  def worksheet_name
    Rails.application.credentials[:google][:google_installment_worksheet_name]
  end

  private

  def destroy_parent_if_void
    invoice.destroy if invoice.try(:installments).try(:count) == 0
  end
end
