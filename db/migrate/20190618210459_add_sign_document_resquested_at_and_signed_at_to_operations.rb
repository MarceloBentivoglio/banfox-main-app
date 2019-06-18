class AddSignDocumentResquestedAtAndSignedAtToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :sign_document_requested_at, :datetime
    add_column :operations, :signed_at, :datetime
  end
end
