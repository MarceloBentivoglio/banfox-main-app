class Operation < ApplicationRecord
  has_many :installments
  has_many :rebuys, dependent: :destroy
end
