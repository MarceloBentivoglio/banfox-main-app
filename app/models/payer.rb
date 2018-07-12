class Payer < ApplicationRecord
  has_many  :invoices, dependent: :destroy
  validates :cnpj,  uniqueness: true
end
