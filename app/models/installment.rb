class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :rebuy, optional: true
  belongs_to :operation, optional: true
  monetize :value_cents, with_model_currency: :currency
  after_destroy :destroy_parent_if_void

  # Helper for other scopes
  scope :from_seller,         -> (seller) { joins(:invoice).where(invoices: {seller: seller}) }

  # For the dashboard
  scope :used_limit,          -> (seller) { from_seller(seller).merge(ordered.or(deposited.opened)) }
  scope :in_analysis,         -> (seller) { from_seller(seller).merge(ordered) }
  scope :opened_today,        -> (seller) { from_seller(seller).merge(opened.where(due_date: Date.current)) }
  scope :opened_week,         -> (seller) { from_seller(seller).merge(opened.where("due_date > :today AND due_date <= :end_week", {today: Date.current, end_week: Date.current.end_of_week})) }
  scope :opened_month,        -> (seller) { from_seller(seller).merge(opened.where("due_date > :end_week AND due_date <= :end_month", {end_week: Date.current.end_of_week, end_month: Date.current.end_of_month})) }
  scope :overdue_upto_7,      -> (seller) { from_seller(seller).merge(opened.where("due_date >= :seven_days_ago AND due_date < :today", {today: Date.current, seven_days_ago: 7.days.ago.to_date})) }
  scope :overdue_upto_30,     -> (seller) { from_seller(seller).merge(opened.where("due_date >= :thirty_days_ago AND due_date <= :seven_days_ago", {seven_days_ago: 7.days.ago.to_date, thirty_days_ago: 30.days.ago.to_date})) }
  scope :overdue_30_plus,     -> (seller) { from_seller(seller).merge(opened.where("due_date < :thirty_days_ago", {thirty_days_ago: 30.days.ago.to_date})) }
  scope :settled,             -> (seller) { from_seller(seller).merge(paid.or(rebought).or(pdd)) }
  scope :total,               -> (scope, seller) { Money.new(__send__(scope, seller).sum(:value_cents)) }
  scope :quant,               -> (scope, seller) { __send__(scope, seller).count }

  # For the tables of cards
  scope :in_store,            -> (seller) { from_seller(seller).merge(available.or(unavailable)).preload(invoice: [:payer]) }
  scope :ordered_in_analysis, -> (seller) { from_seller(seller).merge(ordered).preload(invoice: [:payer]) }
  scope :currently_opened,    -> (seller) { from_seller(seller).merge(deposited.opened).preload(invoice: [:payer]) }
  scope :finished,            -> (seller) { from_seller(seller).merge(deposited.merge(paid.or(rebought).or(pdd))).preload(invoice: [:payer]) }


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

  INSTALLMENT_STATUS = [
    "Em análise",
    "Aprovada",
    "Rejeitada",
    "Cancelada",
    "A vencer",
    "Vence hoje",
    "Em atraso",
    "Liquidada",
    "Recomprada",
    "Perdida",
  ].freeze

  def status
    return INSTALLMENT_STATUS[0] if ordered?
    return INSTALLMENT_STATUS[1] if approved?
    return INSTALLMENT_STATUS[2] if rejected?
    return INSTALLMENT_STATUS[3] if cancelled?
    return INSTALLMENT_STATUS[4] if on_date?
    return INSTALLMENT_STATUS[5] if due_today?
    return INSTALLMENT_STATUS[6] if overdue?
    return INSTALLMENT_STATUS[7] if paid?
    return INSTALLMENT_STATUS[8] if rebought?
    return INSTALLMENT_STATUS[9] if pdd?
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
    days = (due_date - Date.current).to_i
  end

  # Fix logic
  def fee
    value * invoice.fee
  end

  def net_value
    value - fee
  end

  private

  def destroy_parent_if_void
    invoice.destroy if invoice.try(:installments).try(:count) == 0
  end
end
