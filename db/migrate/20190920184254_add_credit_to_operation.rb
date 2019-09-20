class AddCreditToOperation < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |t|
      t.integer :credit_cents
    end
  end
end
