class Payer < ApplicationRecord
  has_many  :invoices, dependent: :destroy
  include UserInputProcessing
  before_validation :clean_inputs, :downcase_words
  validates :cnpj,  uniqueness: true

  enum company_type: {
    ltda: 0,
    sa: 1,
    me: 2,
    mei: 3,
    epp: 4,
  }
end
