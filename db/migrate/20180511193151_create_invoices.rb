class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.integer :invoice_type
      t.string :number
      t.string :import_ref
      t.references :seller, index: true, foreign_key: true
      t.references :payer, index: true, foreign_key: true


      t.timestamps
    end
  end
end
