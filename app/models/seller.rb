class Seller < ApplicationRecord
  # validates :company_name, presence: true
  # validates :full_name, presence: true
  # validates :cpf, presence: true
  # validates :cnpj, presence: true
  has_many :users
  has_many :company_purposes
  has_many :purposes, through: :company_purposes

  # We need this to upload the invoices in xml format and the cheques in pdf
  # has_attached_file :invoice_document
end
