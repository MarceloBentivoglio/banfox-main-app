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
  scope :not_deposited_aux,  -> { joins(:installments).where(backoffice_status: [0,1]).group("invoices.id") }
  scope :deposited_aux_g,    -> { joins(:installments).deposited.group("invoices.id") }
  scope :deposited_aux,      -> { joins(:installments).deposited }
  scope :in_store,           -> { not_deposited_aux.having("SUM(CASE WHEN (liquidation_status = 0) THEN 1 ELSE 0 END) > 0").order(Arel.sql("max(installments.due_date) DESC")) }
  scope :overdue,            -> { deposited_aux_g.having("SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) > 0").order(Arel.sql("max(installments.due_date) ASC")) }
  scope :on_date,            -> { deposited_aux_g.having("SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) ASC")) }
  scope :opened,             -> { deposited_aux_g.having("(SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)) OR (SUM(CASE WHEN (liquidation_status = 0) AND (installments.due_date < NOW()) THEN 1 ELSE 0 END) > 0)").order(Arel.sql("max(installments.due_date) ASC")) }
  scope :paid,               -> { deposited_aux_g.having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC")) }
  scope :rebought,           -> { deposited_aux_g.having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC")) }
  scope :lost,               -> { deposited_aux_g.having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").order(Arel.sql("max(installments.due_date) DESC")) }
  scope :finished,           -> { deposited_aux_g.having("(SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)) OR (SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)) OR (SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status))").order(Arel.sql("max(installments.due_date) DESC")) }
  scope :sum_opened,         -> { deposited_aux.merge(Installment.opened).sum(:value_cents) }
  scope :sum_opened_today,   -> { deposited_aux.merge(Installment.opened_today).sum(:value_cents) }
  scope :count_opened_today, -> { deposited_aux.merge(Installment.opened_today).count }
  scope :sum_opened_week,    -> { deposited_aux.merge(Installment.opened_week).sum(:value_cents) }
  scope :count_opened_week,  -> { deposited_aux.merge(Installment.opened_week).count }
  scope :sum_opened_month,   -> { deposited_aux.merge(Installment.opened_month).sum(:value_cents) }
  scope :count_opened_month, -> { deposited_aux.merge(Installment.opened_month).count }

  def self.total_opened(seller)
    Money.new(where(seller: seller).sum_opened)
  end

  def self.total_opened_today(seller)
    Money.new(where(seller: seller).sum_opened_today)
  end

  def self.quantity_opened_today(seller)
    where(seller: seller).count_opened_today
  end

  def self.total_opened_week(seller)
    Money.new(where(seller: seller).sum_opened_week)
  end

  def self.quantity_opened_week(seller)
    where(seller: seller).count_opened_week
  end

  def self.total_opened_month(seller)
    Money.new(where(seller: seller).sum_opened_month)
  end

  def self.quantity_opened_month(seller)
    where(seller: seller).count_opened_month
  end

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
      return INVOICE_STATUS[4] if installments.any? {|installment| installment.opened? && installment.due_date < Date.current}
      return INVOICE_STATUS[3] if installments.any? {|installment| installment.opened? && installment.due_date == Date.current}
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
