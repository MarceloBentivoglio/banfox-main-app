class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy
  has_one_attached :document, dependent: :purge

  enum invoice_type: {
    invoice_type_not_set: 0,
    contract:             1,
    traditional_invoice:  2,
    check:                3,
  }

  def fee
    fator = [seller.fator, payer.fator].max
    advalorem = [seller.advalorem, payer.advalorem].max
    fator + advalorem
  end

  def protection_rate
    seller.protection
  end
end
