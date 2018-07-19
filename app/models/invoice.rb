class Invoice < ApplicationRecord
  belongs_to :payer, optional: true
  belongs_to :seller, optional: true
  belongs_to :operation, optional: true
  has_many :installments, dependent: :destroy
  has_many_attached :xmls, dependent: :purge
  after_destroy :destroy_parent_if_void

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

# No one can change the order of this array without reflecting the changes on the status invoice method
  INVOICE_STATUS = [
    "Em análise",
    "Aprovado",
    "A vencer",
    "Vence hoje",
    "Em atraso",
    "Liquidado",
    "Recomprado",
    "Perdido",
    "Parcialmente recomprado",
    "Parcialmente perdido",
  ]

  # TODO: Use Joia's email to guide me to getting a better querry performance
  # TODO: There is a warning that says that for rails 6.0 the comand oder(max(installments.due_date) DESC) won't work anymore
  scope :in_store, -> {joins(:installments).where(backoffice_status: [0,1]).group("invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) THEN 1 ELSE 0 END) > 0").order(Arel.sql("max(installments.due_date) DESC"))}
  scope :overdue, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) > 0").order(Arel.sql("max(installments.due_date) ASC"))}
  scope :on_date, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) ASC"))}
  scope :opened, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("(SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)) OR (SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) > 0)").order(Arel.sql("max(installments.due_date) ASC"))}
  scope :paid, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC"))}
  scope :rebought, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC"))}
  scope :lost, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC"))}
  scope :finished, -> {joins(:installments).where(backoffice_status: 2).group("invoices.id").having("(SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)) OR (SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)) OR (SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status))").order(Arel.sql("max(installments.due_date) DESC"))}

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
      return INVOICE_STATUS[4] if installments.any? {|installment| installment.open? && installment.due_date < Date.current}
      return INVOICE_STATUS[3] if installments.any? {|installment| installment.open? && installment.due_date == Date.current}
      return INVOICE_STATUS[5] if installments.all? {|installment| installment.paid?}
      return INVOICE_STATUS[6] if installments.all? {|installment| installment.rebought?}
      return INVOICE_STATUS[7] if installments.all? {|installment| installment.pdd?}
      return INVOICE_STATUS[9] if installments.any? {|installment| installment.pdd?}
      return INVOICE_STATUS[8] if installments.any? {|installment| installment.rebought?}
      return INVOICE_STATUS[2]
    end
  end

  private

  def destroy_parent_if_void
    operation.destroy if operation.try(:invoices).try(:count) == 0
    payer.destroy if payer.try(:invoices).try(:count) == 0
  end
end
