class CreateInstallments < ActiveRecord::Migration[5.1]
  def change
    create_table   :installments do |t|
      t.string     :number
      t.monetize   :value
      t.date       :due_date
      t.date       :order_date
      t.date       :deposit_date
      t.date       :receipt_date
      t.integer    :backoffice_status
      t.integer    :liquidation_status
      t.integer    :unavailability
      t.integer    :rejection_motive
      t.string     :import_ref
      t.references :invoice, index: true, foreign_key: true
      t.references :rebuy, index: true, foreign_key: true
      t.references :operation, index: true, foreign_key: true

      t.timestamps
    end
  end
end
