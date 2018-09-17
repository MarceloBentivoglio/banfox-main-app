class Order < ApplicationRecord
  before_destroy :uncouple_installments
  has_many :installments

  private

  def uncouple_installments
    installments.each do |installment|
      installment.order = nil
      installment.save!
    end
  end
end
