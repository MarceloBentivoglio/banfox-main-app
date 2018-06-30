class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  belongs_to :operation, optional: true
  has_many :installments, dependent: :destroy
  has_many_attached :xmls, dependent: :purge

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

# One can't change the order of this array without reflecting the change on the status invoice method
  INVOICE_STATUS = [
    "Título em análise",
    "Titulo aprovado",
    "Título a vencer",
    "Título liquidado",
    "Título recomprado",
    "Título em atraso",
  ]

  def total_value
    Money.new(installments.sum("value_cents"))
  end

  def total_value_w_installments_preloaded
    Money.new(installments.reduce(0){ |sum, i| sum + i.value_cents })
  end

  def status
    return INVOICE_STATUS[0] if registred?
    return INVOICE_STATUS[1] if approved?
    if deposited?
      return INVOICE_STATUS[3] if installments.all? {|installment| installment.paid?}
      return INVOICE_STATUS[4] if installments.all? {|installment| installment.rebought?}
      return INVOICE_STATUS[5] if installments.any? {|installment| installment.open? && installment.due_date < Date.today}
      return INVOICE_STATUS[2]
    end
  end
  # TODO: Use Joia's email to guide me to getting a better querry performance
  def self.in_store(seller)
    where(backoffice_status: 0).or(Invoice.where(backoffice_status: 1)).where(seller: seller)
  end

  def self.overdue(seller)
    joins(:installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("invoices.id").having("SUM(CASE WHEN (installments.liquidation_status = 0) AND (installments.due_date <= NOW()) THEN 1 ELSE 0 END) > 0")
  end

  def self.on_date(seller)
    joins(:installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date <= NOW()) THEN 1 ELSE 0 END) < 1 AND SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) < COUNT(liquidation_status)")
  end

  def self.opened(seller)
    overdue(seller).or(on_date(seller))
  end

  def self.paid(seller)
    joins(:installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("invoices.id").having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.rebought(seller)
    joins(:installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("invoices.id").having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.lost(seller)
    joins(:installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("invoices.id").having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.finished(seller)
    paid(seller).or(rebought(seller)).or(lost(seller))
  end
end
