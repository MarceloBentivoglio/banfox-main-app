class CreateRebuys < ActiveRecord::Migration[5.2]
  def change
    create_table :rebuys do |t|
      t.string     :import_ref
      t.references :operation, index: true, foreign_key: true

      t.timestamps
    end
  end
end
