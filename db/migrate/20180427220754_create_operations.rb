class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.boolean :consent, null: false, default: false
      t.string  :import_ref
      t.boolean :signed, default: :false
      t.jsonb   :sign_document_info
      t.string  :sign_document_key

      t.timestamps
    end
  end
end
