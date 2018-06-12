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

  # TODO: transform all sql on Active Record
  def self.in_store(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      WHERE (a.backoffice_status = 0 OR a.backoffice_status = 1) AND a.seller_id = ?", seller.id])
  end

  def self.overdue(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      JOIN installments b ON a.id = b.invoice_id
      WHERE a.backoffice_status = 2 AND a.seller_id = ?
      GROUP BY a.id
      HAVING SUM(CASE WHEN (liquidation_status = 0) AND (due_date <= NOW()) THEN 1 ELSE 0 END) > 0", seller.id])
  end
  # NOTE: the upper querry performers better than the one below! But will let this one just in case
  def self.overdue_2(seller_invoices)
    seller_invoices ||= self
    date_range_past = (Date.today - 6.years)...(Date.today)
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "open", due_date: date_range_past})
  end

  def self.opened(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      JOIN installments b ON a.id = b.invoice_id
      WHERE a.backoffice_status = 2 AND a.seller_id = ?
      GROUP BY a.id
      HAVING SUM(CASE WHEN (liquidation_status = 0) AND (due_date <= NOW()) THEN 1 ELSE 0 END) < 1 AND SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) < COUNT(liquidation_status)", seller.id])
  end

  def self.paid(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      JOIN installments b ON a.id = b.invoice_id
      WHERE a.backoffice_status = 2 AND a.seller_id = ?
      GROUP BY a.id
      HAVING SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status) ", seller.id])
  end
  # NOTE: the upper querry performers better than the one below! But will let this one just in case
  def self.paid_2(seller_invoices)
    seller_invoices ||= self
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "paid"}).distinct.select { |invoice|
      invoice.installments.all? {|installment| installment.paid?}
    }
  end

  def self.rebought(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      JOIN installments b ON a.id = b.invoice_id
      WHERE a.backoffice_status = 2 AND a.seller_id = ?
      GROUP BY a.id
      HAVING SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)", seller.id])
  end
  # NOTE: the upper querry performers better than the one below! But will let this one just in case
  def self.rebought_2(seller_invoices)
    seller_invoices ||= self
    seller_invoices.deposited.joins(:installments).where(installments: {liquidation_status: "rebought"}).distinct.select { |invoice|
      invoice.installments.all? {|installment| installment.rebought?}
    }
  end

  def self.lost(seller)
    find_by_sql(["
      SELECT a.* FROM invoices a
      JOIN installments b ON a.id = b.invoice_id
      WHERE a.backoffice_status = 2 AND a.seller_id = ?
      GROUP BY a.id
      HAVING SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)", seller.id])
  end
end
