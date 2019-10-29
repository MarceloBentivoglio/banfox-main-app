class BillingRulersInstallments < ApplicationRecord
  belongs_to :billing_ruler
  belongs_to :installment
end

