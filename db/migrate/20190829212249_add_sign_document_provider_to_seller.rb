class AddSignDocumentProviderToSeller < ActiveRecord::Migration[5.2]
  def change
    change_table :sellers do |t|
      t.integer :sign_documents_provider
    end
  end
end
