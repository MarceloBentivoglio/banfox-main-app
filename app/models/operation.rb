class Operation < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :rebuys, dependent: :destroy

  def self.in_store_not_preloaded(seller)
    includes(:invoices).where("invoices.backoffice_status" => 0).or(Operation.includes(:invoices).where("invoices.backoffice_status" => 1)).where("invoices.seller" => seller)
  end

  def self.in_store(seller)
    in_store_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

  def self.overdue_not_preloaded(seller)
    joins(invoices: :installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("operations.id").having("SUM(CASE WHEN (installments.liquidation_status = 0) AND (installments.due_date <= NOW()) THEN 1 ELSE 0 END) > 0")
  end

  def self.overdue
    overdue_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

  def self.opened_not_preloaded(seller)
    joins(invoices: :installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("operations.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date <= NOW()) THEN 1 ELSE 0 END) < 1 AND SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) < COUNT(liquidation_status)")
  end

  def self.opened
    opened_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

  def self.paid_not_preloaded(seller)
    joins(invoices: :installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("operations.id").having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.paid
    paid_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

  def self.rebought_not_preloaded(seller)
    joins(invoices: :installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("operations.id").having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.rebought
    rebought_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

  def self.lost_not_preloaded(seller)
    joins(invoices: :installments).where("invoices.backoffice_status" => 2).where("invoices.seller" => seller).group("operations.id").having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)")
  end

  def self.lost
    lost_not_preloaded(seller).preload(invoices: [:installments, :payer])
  end

end
