class AddDocumentStatusToOperation < ActiveRecord::Migration[5.2]
  def change
    change_table :operations do |t|
      t.integer :document_status, default: 0
    end
  end
end
