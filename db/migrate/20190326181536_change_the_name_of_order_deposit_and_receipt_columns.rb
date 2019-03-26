class ChangeTheNameOfOrderDepositAndReceiptColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :installments, :order_date, :ordered_at
    rename_column :installments, :deposit_date, :deposited_at
    rename_column :installments, :receipt_date, :received_at
  end
end
