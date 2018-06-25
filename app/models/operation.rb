class Operation < ApplicationRecord
  has_many :invoices
  has_many :rebuys
end
