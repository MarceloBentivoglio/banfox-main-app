class AddImportationReferenceToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :import_ref, :string
    add_column :installments, :import_ref, :string
    add_column :operations, :import_ref, :string
    add_column :rebuys, :import_ref, :string
    add_column :payers, :import_ref, :string
  end
end
