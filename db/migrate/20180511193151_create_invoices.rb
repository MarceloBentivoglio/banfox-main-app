class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :invoice_type
      t.string :number
      t.belongs_to :seller
      t.timestamps
    end
  end
end
