class AddKeyIndicatorsToKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.jsonb :key_indicators, default: {}
    end
  end
end
