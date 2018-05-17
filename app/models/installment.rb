class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
  monetize :value_cents, with_model_currency: :currency
end
