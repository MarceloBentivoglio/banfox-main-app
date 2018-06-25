class Operation < ApplicationRecord
  has_many :invoices, dependent: :destroy
  has_many :rebuys
end
