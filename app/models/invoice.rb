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
    [seller.fator, payer.fator].max
  end

  def advalorem
    [seller.advalorem, payer.advalorem].max
  end

  def fee
    fator + advalorem
  end

  def protection_rate
    seller.protection
  end
end
