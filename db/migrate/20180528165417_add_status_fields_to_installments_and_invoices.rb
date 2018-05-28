class AddStatusFieldsToInstallmentsAndInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :installments, :liquidation_status, :integer, default: 0
    add_column :installments, :deposit_date, :date
    add_column :installments, :receipt_date, :date
    add_column :invoices, :backoffice_status, :integer, default: 0

  end
end
