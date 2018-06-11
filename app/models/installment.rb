class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  monetize :value_cents, with_model_currency: :currency

# Any change in this enum must be reflected on the sql querry in Invoice Model
  enum liquidation_status: {
    open: 0,
    paid: 1,
    rebought: 2,
    pdd: 3,
  }
end
