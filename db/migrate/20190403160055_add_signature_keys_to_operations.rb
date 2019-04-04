class AddSignatureKeysToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :signature_keys, :jsonb
  end
end
