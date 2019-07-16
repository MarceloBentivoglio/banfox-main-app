class CreateKeyRiskIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :key_risk_indicators do |t|
      t.string :code
      t.string :title
      t.string :description
      t.integer :flag
      t.integer :scope

      t.timestamps
    end
  end
end
