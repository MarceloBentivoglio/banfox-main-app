class AddOrderToInstallments < ActiveRecord::Migration[5.2]
  def change
    add_reference :installments, :order, foreign_key: true
  end
end
