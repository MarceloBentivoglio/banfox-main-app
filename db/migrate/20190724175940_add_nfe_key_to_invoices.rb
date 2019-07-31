class AddNfeKeyToInvoices < ActiveRecord::Migration[5.2]
  def change
    change_table :invoices do |t|
      t.string  :nfe_key
    end
  end
end
