class AddOperationidToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :operation, foreign_key: true
  end
end
