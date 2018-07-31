class CreateInstallments < ActiveRecord::Migration[5.1]
  def change
    create_table :installments do |t|
      t.string :number
      t.monetize :value
      t.date :due_date
      t.date :receipt_date
      t.integer :liquidation_status, default: 0
      t.string :import_ref
      t.references :invoice, index: true, foreign_key: true
      t.references :rebuy, index: true, foreign_key: true

      t.timestamps
    end
  end
end
