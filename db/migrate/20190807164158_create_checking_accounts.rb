class CreateCheckingAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :checking_accounts do |t|
      t.references :seller, foreign_key: true
      t.string :document
      t.string :name
      t.string :account_number
      t.string :branch
      t.string :bank_code
      t.string :bank_name

      t.timestamps
    end
  end
end
