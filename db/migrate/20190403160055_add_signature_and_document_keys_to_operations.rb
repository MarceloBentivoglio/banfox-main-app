class AddSignatureAndDocumentKeysToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :sign_document_info, :jsonb
    add_column :operations, :sign_document_key, :string
  end
end
