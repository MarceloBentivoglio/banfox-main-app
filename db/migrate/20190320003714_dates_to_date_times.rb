class DatesToDateTimes < ActiveRecord::Migration[5.2]
  def change
    remove_column :installments, :order_date
    remove_column :installments, :deposit_date
    remove_column :installments, :receipt_date
    add_column :installments, :order_date, :datetime
    add_column :installments, :deposit_date, :datetime
    add_column :installments, :receipt_date, :datetime
  end
end
