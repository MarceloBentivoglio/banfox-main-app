class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy
  has_many_attached :xmls, dependent: :purge
  after_destroy :destroy_parent_if_void

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

  private

  def destroy_parent_if_void
    payer.destroy if payer.try(:invoices).try(:count) == 0
  end
end
