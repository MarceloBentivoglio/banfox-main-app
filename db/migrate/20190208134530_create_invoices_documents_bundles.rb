class CreateInvoicesDocumentsBundles < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices_documents_bundles do |t|

      t.timestamps
    end
  end
end
