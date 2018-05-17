class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy

  enum invoice_type: {
    contract: 0,
    traditional_invoice: 1,
    check: 2,
  }

  has_one_attached :xml

  def self.from_file(file)
    extract = ExtractDataFromXml.new
    invoice = extract.invoice(file)
  end

end
