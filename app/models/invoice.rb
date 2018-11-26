class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy
  has_many_attached :xmls, dependent: :purge

  enum invoice_type: {
    contract:             0,
    traditional_invoice:  1,
    check:                2,
  }

  def fee
    fator = [seller.fator, seller.fator].max
    advalorem = [seller.advalorem, seller.advalorem].max
    fator + advalorem
  end
end
