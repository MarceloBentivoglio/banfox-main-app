class AddSignedToOperations < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :signed, :boolean, default: :false
  end
end
