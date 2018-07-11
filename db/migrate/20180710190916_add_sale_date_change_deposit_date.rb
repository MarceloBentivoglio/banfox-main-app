class AddSaleDateChangeDepositDate < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :sale_date, :date
    add_column :invoices, :deposit_date, :date
    remove_column :installments, :deposit_date, :date
  end
end
