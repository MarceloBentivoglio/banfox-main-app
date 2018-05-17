class Invoice < ApplicationRecord
  belongs_to :payer
  belongs_to :seller
  has_many :installments, dependent: :destroy

  enum invoice_type: {
    contract: 0,
    traditional_invoice: 1,
    check: 2,
  }

  # We need this to upload the invoices in xml format and the cheques in pdf
  # has_attached_file :invoice_document

  # We need this to upload the invoices in xml format
  has_attached_file :xml_file
end
