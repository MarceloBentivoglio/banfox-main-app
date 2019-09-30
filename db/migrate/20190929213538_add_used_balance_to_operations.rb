class AddUsedBalanceToOperations < ActiveRecord::Migration[5.2]
  def change
    remove_column :operations, :credit_cents, :integer
    add_monetize :operations, :used_balance
  end
end
