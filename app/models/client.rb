class Client < ApplicationRecord
  validates :company_name, presence: true
  validates :full_name, presence: true
  validates :cpf, presence: true
  validates :cnpj, presence: true
end
