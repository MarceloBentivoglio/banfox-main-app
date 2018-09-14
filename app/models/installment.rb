class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :rebuy, optional: true
  monetize :value_cents, with_model_currency: :currency
  after_destroy :destroy_parent_if_void

  scope :opened_today,    -> { opened.where(due_date: Date.current) }
  scope :opened_week,     -> { opened.where("due_date > :today AND due_date <= :end_week", {today: Date.current, end_week: Date.current.end_of_week}) }
  scope :opened_month,    -> { opened.where("due_date > :end_week AND due_date <= :end_month", {end_week: Date.current.end_of_week, end_month: Date.current.end_of_month}) }
  scope :overdue_upto_7,  -> { opened.where("due_date >= :seven_days_ago AND due_date < :today", {today: Date.current, seven_days_ago: 7.days.ago.to_date}) }
  scope :overdue_upto_30, -> { opened.where("due_date >= :thirty_days_ago AND due_date <= :seven_days_ago", {seven_days_ago: 7.days.ago.to_date, thirty_days_ago: 30.days.ago.to_date}) }
  scope :overdue_30_plus, -> { opened.where("due_date < :thirty_days_ago", {thirty_days_ago: 30.days.ago.to_date}) }
  scope :settled,         -> { paid.or(rebought) }

# Any change in this enum must be reflected on the sql querry in Invoice Model
  enum liquidation_status: {
    opened: 0,
    paid: 1,
    rebought: 2,
    pdd: 3,
  }

  INSTALLMENT_STATUS = [
    "A vencer",
    "Vence hoje",
    "Em atraso",
    "Paga",
    "Recomprada",
    "Perdida",
  ].freeze

  def status
    return INSTALLMENT_STATUS[0] if on_date?
    return INSTALLMENT_STATUS[1] if due_today?
    return INSTALLMENT_STATUS[2] if overdue?
    return INSTALLMENT_STATUS[3] if paid?
    return INSTALLMENT_STATUS[4] if rebought?
    return INSTALLMENT_STATUS[5] if pdd?
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
    return days if days >= 0
    return 0 if days < 0
  end

  def fee
    value * invoice.fee
  end

  def deposit_value
    value - fee
  end

  private

  def destroy_parent_if_void
    invoice.destroy if invoice.try(:installments).try(:count) == 0
  end
end
