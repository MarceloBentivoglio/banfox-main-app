# == Schema Information
#
# Table name: payers
#
#  id             :bigint           not null, primary key
#  company_name   :string
#  cnpj           :string
#  inscr_est      :string
#  inscr_mun      :string
#  nire           :string
#  company_type   :integer
#  email          :string
#  phone          :string
#  address        :string
#  address_number :string
#  address_comp   :string
#  neighborhood   :string
#  state          :string
#  city           :string
#  zip_code       :string
#  import_ref     :string
#  fator          :decimal(, )
#  advalorem      :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

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
