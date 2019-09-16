class AddSignDocumentsProviderToOperation < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |t|
      t.integer :sign_documents_provider
    end
  end
end
