class CreateAnalyzedParts < ActiveRecord::Migration[5.2]
  def change
    create_table :analyzed_parts do |t|
      t.belongs_to :key_indicator_report, foreign_key: true
      t.string :cnpj

      t.timestamps
    end
  end
end
