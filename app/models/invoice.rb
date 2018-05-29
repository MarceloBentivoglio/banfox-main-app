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
    if deposited?
      return "Título liquidado" if installments.all? {|installment| installment.paid?}
      return "Título em atraso" if installments.any? {|installment| installment.open? && installment.due_date < Date.today}
      return "Atecipação depositada" if installments.all? {|installment| installment.open?}
    end
  end

end
