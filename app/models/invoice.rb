class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy
  has_many_attached :xmls, dependent: :purge

  enum invoice_type: {
    not_setted:           0,
    contract:             1,
    traditional_invoice:  2,
    check:                3,
  }

  def fee
    fator = [seller.fator, seller.fator].max
    advalorem = [seller.advalorem, seller.advalorem].max
    fator + advalorem
  end
end
