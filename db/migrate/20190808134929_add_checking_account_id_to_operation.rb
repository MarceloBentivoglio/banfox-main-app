class AddCheckingAccountIdToOperation < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |t|
      t.integer :checking_account_id
    end
  end
end
