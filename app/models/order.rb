class Order < ApplicationRecord
  has_many :invoices
end
