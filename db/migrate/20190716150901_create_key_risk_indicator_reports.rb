class CreateKeyRiskIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    create_table :key_risk_indicator_reports do |t|
      t.jsonb :input_data
      t.string :pipeline

      t.timestamps
    end
  end
end
