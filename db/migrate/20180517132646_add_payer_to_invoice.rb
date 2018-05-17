class AddPayerToInvoice < ActiveRecord::Migration[5.1]
  def change
    add_reference :invoices, :payer, foreign_key: true
  end
end
