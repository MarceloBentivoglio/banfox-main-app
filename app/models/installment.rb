class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :rebuy, optional: true
  belongs_to :operation, optional: true
  monetize :value_cents, with_model_currency: :currency

  after_destroy :destroy_parent_if_void
  after_update :async_update_spreadsheet

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
  scope :settled,             -> (seller) { from_seller(seller).merge(paid.or(rebought).or(pdd)) }
  scope :total,               -> (scope, seller) { Money.new(__send__(scope, seller).sum(:value_cents)) }
  scope :quant,               -> (scope, seller) { __send__(scope, seller).count }

  # For the tables of cards
  scope :in_store,            -> (seller) { from_seller(seller).merge(unavailable.or(available)).preload(invoice: [:payer]) }
  scope :currently_opened,    -> (seller) { from_seller(seller).merge(deposited.opened).preload(invoice: [:payer]) }
  scope :finished,            -> (seller) { from_seller(seller).merge(deposited.merge(paid.or(rebought).or(pdd))).preload(invoice: [:payer]) }

  # For creating operations
  scope :ordered_in_analysis, -> (seller) { from_seller(seller).merge(ordered).preload(invoice: [:payer]) }
  include Trackable

# Any change in this enum must be reflected on the sql querry in Invoice Model
  enum liquidation_status: {
    opened:     0,
    paid:       1,
    rebought:   2,
    pdd:        3,
  }

  enum backoffice_status: {
    unavailable:      0,
    available:        1,
    approved:         2,
    rejected:         3,
    rejected_consent: 4,
    cancelled:        5,
    ordered:          6,
    deposited:        7,
  }

  enum unavailability: {
    due_date_past:              0,
    due_date_later_than_limit:  1,
    already_operated:           2,
  }

  enum rej_motive: {
    fake:             0,
    payer_low_rated:  1,
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
      rebought: "Recomprada",
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

  def outstanding_days
    days = (due_date - (order_date || Date.current)).to_i
  end

  def fee
    value * (((1 + invoice.fee) ** (outstanding_days / 30)) - 1)
  end

  def net_value
    value - fee
  end

  def installment_attributes
    {
      operation_id: self.operation_id,
      invoice_id: self.invoice_id,
      payer_id: self.invoice.payer_id,
      payer_name: self.invoice.payer.company_name,
      payer_cnpj: self.invoice.payer.cnpj,
      id: self.id,
      rebuy_id: self.rebuy_id,
      status: self.status[1],
      number: self.number,
      value_cents: self.value_cents,
      value_currency: self.value_currency,
      due_date: self.due_date.try(:strftime),
      order_date: self.order_date.try(:strftime),
      deposit_date: self.deposit_date.try(:strftime),
      receipt_date: self.receipt_date.try(:strftime),
      backoffice_status: self.backoffice_status,
      liquidation_status: self.liquidation_status,
      unavailability: self.unavailability,
      rej_motive: self.rej_motive,
    }.stringify_keys
  end

  def async_update_spreadsheet
    SpreadsheetsRowSetterJob.perform_later(spreadsheet_id, worksheet_name, self.row, self.installment_attributes)
  end

  def spreadsheet_id
    Rails.application.credentials[Rails.env.to_sym][:google_spreadsheet_id]
  end

  def worksheet_name
    Rails.application.credentials[:google][:google_installment_worksheet_name]
  end

  def self.number_of_new_row
    (row_number = self.maximum(:row)) ? row_number + 1 : 2
  end

  private

  def destroy_parent_if_void
    invoice.destroy if invoice.try(:installments).try(:count) == 0
  end
end
