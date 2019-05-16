class Payer < ApplicationRecord
  has_many  :invoices, dependent: :destroy
  include UserInputProcessing
  before_validation :clean_inputs, :downcase_words
  validates :cnpj,  uniqueness: true

  enum company_type: {
    company_type_not_set: 0,
    ei:                   1,
    eireli:               2,
    me:                   3,
    mei:                  4,
    epp:                  5,
    ltda:                 6,
    sa:                   7,
    ss:                   8,
  }
end
