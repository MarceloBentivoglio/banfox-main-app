class Balance < ApplicationRecord
  belongs_to :seller
  belongs_to :installment
  monetize :value_cents, with_model_currency: :currency
end
