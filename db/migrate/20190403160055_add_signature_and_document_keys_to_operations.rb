class AddSignatureAndDocumentKeysToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :signature_keys, :jsonb
    add_column :operations, :sign_document_key, :string
  end
end
