class Payer < ApplicationRecord
  has_many  :invoices, dependent: :destroy
  validates :cnpj,  uniqueness: true

  enum company_type: {
    ltda: 0,
    sa: 1,
    me: 2,
    mei: 3,
    epp: 4,
  }

end
