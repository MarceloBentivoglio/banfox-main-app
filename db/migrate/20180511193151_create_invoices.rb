class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.integer :invoice_type
      t.string :number
      t.references :seller, foreign_key: true
      t.references :payer, foreign_key: true
      t.timestamps
    end
  end
end
