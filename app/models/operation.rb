class Operation < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :rebuys, dependent: :destroy
  has_many :in_store_invoices, -> {in_store}, class_name: "Invoice"
  has_many :overdue_invoices,  -> {overdue},  class_name: "Invoice"
  has_many :on_date_invoices,  -> {on_date},  class_name: "Invoice"
  has_many :opened_invoices,   -> {opened},   class_name: "Invoice"
  has_many :paid_invoices,     -> {paid},     class_name: "Invoice"
  has_many :rebought_invoices, -> {rebought}, class_name: "Invoice"
  has_many :lost_invoices,     -> {lost},     class_name: "Invoice"
  has_many :finished_invoices, -> {finished}, class_name: "Invoice"

  scope :deposited_aux_g,      -> (seller) { joins(invoices: :installments).where(invoices: {backoffice_status: 2, seller: seller}).group("operations.id, invoices.id") }
  scope :preload_scope,        -> (scope, seller) { __send__(scope, seller).preload("#{scope}_invoices" => [:installments, :payer]) }
  scope :in_store,             -> (seller) { includes(:invoices).where(invoices: {backoffice_status: 0}).or(self.includes(:invoices).where(invoices: {backoffice_status: 1})).where(invoices: {seller: seller}) }
  scope :overdue,              -> (seller) { deposited_aux_g(seller).having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date < NOW()) THEN 1 ELSE 0 END) > 0").distinct }
  scope :on_date,              -> (seller) { deposited_aux_g(seller).having("SUM(CASE WHEN (liquidation_status = 0) AND (due_date < NOW()) THEN 1 ELSE 0 END) = 0 AND SUM(CASE WHEN liquidation_status > 0 THEN 1 ELSE 0 END) < COUNT(liquidation_status)").distinct }
  scope :opened,               -> (seller) { overdue(seller).or(on_date(seller)) }
  scope :paid,                 -> (seller) { deposited_aux_g(seller).having("SUM(CASE liquidation_status WHEN 1 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct }
  scope :rebought,             -> (seller) { deposited_aux_g(seller).having("SUM(CASE liquidation_status WHEN 2 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct }
  scope :lost,                 -> (seller) { deposited_aux_g(seller).having("SUM(CASE liquidation_status WHEN 3 THEN 1 ELSE 0 END) = COUNT(liquidation_status)").distinct }
  scope :finished,             -> (seller) { paid(seller).or(rebought(seller)).or(lost(seller)) }
end
