class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  has_many :installments, dependent: :destroy

  enum invoice_type: {
    contract: 0,
    traditional_invoice: 1,
    check: 2,
  }

  enum backoffice_status: {
    registred: 0,
    approved: 1,
    deposited: 2,
  }

  has_one_attached :xml

  def total_value
    Money.new(installments.sum("value_cents"))
  end

  def status_for_client
    return "Título em análise" if registred?
    return "Titulo aprovado" if approved?
    return "Adiantamento depositado" if deposited?
  end

end
