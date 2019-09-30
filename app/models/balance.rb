class Balance < ApplicationRecord
  belongs_to :seller
  belongs_to :installment, optional: true
  belongs_to :operation, optional: true
  monetize :value_cents, with_model_currency: :currency
end
