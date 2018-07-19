class Operation < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :rebuys, dependent: :destroy
  has_many :in_store_invoices, -> {in_store}, class_name: "Invoice"
  has_many :overdue_invoices, -> {overdue}, class_name: "Invoice"
  has_many :on_date_invoices, -> {on_date}, class_name: "Invoice"
  has_many :opened_invoices, -> {opened}, class_name: "Invoice"
  has_many :paid_invoices, -> {paid}, class_name: "Invoice"
  has_many :rebought_invoices, -> {rebought}, class_name: "Invoice"
  has_many :lost_invoices, -> {lost}, class_name: "Invoice"
  has_many :finished_invoices, -> {finished}, class_name: "Invoice"

  def self.in_store_not_preloaded(seller)
    includes(:invoices).where(invoices: {backoffice_status: 0}).or(self.includes(:invoices).where(invoices: {backoffice_status: 1})).where(invoices: {seller: seller})
  end

  def self.in_store(seller)
    in_store_not_preloaded(seller).preload(in_store_invoices: [:installments, :payer])
  end

  def self.overdue_not_preloaded(seller)
    joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date < NOW()) THEN 1 ELSE 0 END) > 0").distinct
  end

  def self.overdue(seller)
    overdue_not_preloaded(seller).preload(overdue_invoices: [:installments, :payer])
  end

  def self.on_date_not_preloaded(seller)
    joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id").having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)").distinct
  end

  def self.on_date(seller)
    on_date_not_preloaded(seller).preload(on_date_invoices: [:installments, :payer])
  end

  def self.opened_not_preloaded(seller)
    overdue_not_preloaded(seller).or(on_date_not_preloaded(seller))
  end

  def self.opened(seller)
    opened_not_preloaded(seller).preload(opened_invoices: [:installments, :payer])
  end

  def self.paid_not_preloaded(seller)
    joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id").having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct
  end

  def self.paid(seller)
    paid_not_preloaded(seller).preload(paid_invoices: [:installments, :payer])
  end

  def self.rebought_not_preloaded(seller)
    joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id").having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct
  end

  def self.rebought(seller)
    rebought_not_preloaded(seller).preload(rebought_invoices: [:installments, :payer])
  end

  def self.lost_not_preloaded(seller)
    joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id").having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct
  end

  def self.lost(seller)
    lost_not_preloaded(seller).preload(lost_invoices: [:installments, :payer])
  end

  def self.finished_not_preloaded(seller)
    paid_not_preloaded(seller).or(rebought_not_preloaded(seller)).or(lost_not_preloaded(seller))
  end

  def self.finished(seller)
    finished_not_preloaded(seller).preload(finished_invoices: [:installments, :payer])
  end
end
