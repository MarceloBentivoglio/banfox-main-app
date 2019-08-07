class CheckingAccount < ApplicationRecord
  belongs_to :seller

  def seller_name
    seller.full_name unless seller.nil?
  end

  def bank_info
    "#{bank_code} - #{bank_name}"
  end
end
