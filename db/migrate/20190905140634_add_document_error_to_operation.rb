class AddDocumentErrorToOperation < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |t|
      t.boolean :sign_document_error, default: false
    end
  end
end
