class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :rebuy, optional: true
  monetize :value_cents, with_model_currency: :currency

# Any change in this enum must be reflected on the sql querry in Invoice Model
  enum liquidation_status: {
    open: 0,
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
  ]

  def status
    return INSTALLMENT_STATUS[0] if on_date?
    return INSTALLMENT_STATUS[1] if due_today?
    return INSTALLMENT_STATUS[2] if overdue?
    return INSTALLMENT_STATUS[3] if paid?
    return INSTALLMENT_STATUS[4] if rebought?
    return INSTALLMENT_STATUS[5] if pdd?

  end

  def overdue?
    open? && due_date < Date.today
  end

  def on_date?
    open? && due_date > Date.today
  end

  def due_today?
    open? && due_date == Date.today
  end
end
