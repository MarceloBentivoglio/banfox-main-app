# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  invoice_type      :integer          default("invoice_type_not_set")
#  number            :string
#  import_ref        :string
#  seller_id         :bigint
#  payer_id          :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  issue_date        :date
#  doc_parser_ref    :string
#  doc_parser_ticket :jsonb
#  doc_parser_data   :jsonb
#

class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy
  has_one_attached :document, dependent: :purge

  enum invoice_type: {
    invoice_type_not_set: 0,
    contract:             1,
    merchandise:          2,
    service:              3,
    check:                4,
  }

  def fator
    seller.fator
  end

  def advalorem
    seller.advalorem
  end

  def fee
    fator + advalorem
  end

  def protection_rate
    seller.protection
  end

  def payer_name
    payer.company_name unless payer.nil?
  end

  def payer_cnpj
    payer.cnpj unless payer.nil?
  end
end
