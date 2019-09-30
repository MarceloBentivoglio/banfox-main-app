class AddOperationToBalance < ActiveRecord::Migration[5.2]
  def change
    add_reference :balances, :operation, foreign_key: true
  end
end
