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

# One can't change the order of this array without reflecting the change on the status invoice method
  INVOICE_STATUS = [
    "Título em análise",
    "Titulo aprovado",
    "Atecipação depositada",
    "Título liquidado",
    "Título recomprado",
    "Título em atraso",
  ]

  has_one_attached :xml

  def total_value
    Money.new(installments.sum("value_cents"))
  end

  def status
    return INVOICE_STATUS[1] if registred?
    return INVOICE_STATUS[2] if approved?
    if deposited?
      return INVOICE_STATUS[4] if installments.all? {|installment| installment.paid?}
      return INVOICE_STATUS[5] if installments.all? {|installment| installment.rebought?}
      return INVOICE_STATUS[6] if installments.any? {|installment| installment.open? && installment.due_date < Date.today}
      return INVOICE_STATUS[3] if installments.all? {|installment| installment.open?}
    end
  end

  # Verificar se essa lógica está certa ou se eu teria que colocar um seller_invoices antes de approved
  def self.in_store(seller_invoices)
    seller_invoices ||= self
    seller_invoices.registred.or(approved)
  end

  def self.overdue(seller_invoices)
    seller_invoices ||= self
    date_range_past = (Date.today - 6.years)...(Date.today)
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "open", due_date: date_range_past})
  end

  def self.opened(seller_invoices)
    seller_invoices ||= self
    date_range_past = (Date.today - 6.years)...(Date.today)
    date_range_future = Date.today..(Date.today + 1.year)
    # seller_invoices.deposited.joins(:installments).where.not(installments: {liquidation_status: "open", due_date: date_range_past}).where(installments: {liquidation_status: "open", due_date: date_range_future})
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "open", due_date: date_range_future}).where.not(installments: {due_date: date_range_past})
  end

  def self.history_paid(seller_invoices)
    seller_invoices ||= self
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "paid"}).distinct.select { |invoice|
      invoice.installments.all? {|installment| installment.paid?}
    }
  end

  def self.history_rebought(seller_invoices)
    seller_invoices ||= self
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "rebought"}).distinct.select { |invoice|
      invoice.installments.all? {|installment| installment.rebought?}
    }
  end

  def self.history(seller_invoices)
    seller_invoices ||= self
    seller_invoices.joins(:installments).where(installments: {liquidation_status: "rebought"}).or(seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "paid"})).distinct.select { |invoice|
      invoice.installments.all? {|installment| installment.rebought? || installment.paid? }
    }

  end

  def self.paid
    invoices = []
    deposited.find_each do |invoice|
      invoices << invoice if invoice.installments.all? {|installment| installment.paid?}
    end
    invoices
  end
end
