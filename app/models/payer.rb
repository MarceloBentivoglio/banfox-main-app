class Payer < ApplicationRecord
  has_many  :invoices, dependent: :destroy
  validates :cnpj,  uniqueness: true

  enum company_type: {
    LTDA: 0,
    SA: 1,
    ME: 2,
    MEI: 3,
  }

end
