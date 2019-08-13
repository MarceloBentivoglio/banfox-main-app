class CheckingAccount < ApplicationRecord
  belongs_to :seller

  def seller_name
    seller.full_name unless seller.nil?
  end

  def bank_info
    "#{bank_code} - #{bank_name}"
  end

  def bank_info_for_select
    "#{bank_code} - #{bank_name} #{branch} #{account_number}"
  end

end
