class CreateExternalData < ActiveRecord::Migration[5.2]
  def change
    create_table :external_data do |t|
      t.string :source
      t.jsonb :query
      t.jsonb :raw_data
      t.belongs_to :key_indicator_report, foreign_key: true

      t.timestamps
    end
  end
end
