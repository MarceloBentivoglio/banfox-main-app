class CreateOperations < ActiveRecord::Migration[5.2]
  def change
    create_table :operations do |t|
      t.string :import_ref

      t.timestamps
    end
  end
end
