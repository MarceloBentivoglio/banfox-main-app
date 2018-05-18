class Payer < ApplicationRecord
  has_many :invoices
end
