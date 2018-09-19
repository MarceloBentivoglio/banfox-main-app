class Operation < ApplicationRecord
  has_many :installments
  has_many :rebuys, dependent: :destroy
  validates :consent, acceptance: {message: "é necessário dar o seu aval para a operação"}
end
