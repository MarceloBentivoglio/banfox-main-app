class Purpose < ApplicationRecord
  has_many :company_purposes
  has_many :sellers, through: :company_purposes
end
