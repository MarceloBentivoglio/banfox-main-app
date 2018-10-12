class AddingRowToInstallment < ActiveRecord::Migration[5.2]
  def change
    add_column :installments, :row, :integer
  end
end
