class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  monetize :value_cents, with_model_currency: :currency

  enum liquidation_status: {
    open: 0,
    paid: 1,
    rebought: 2,
    pdd: 3,
  }
end
