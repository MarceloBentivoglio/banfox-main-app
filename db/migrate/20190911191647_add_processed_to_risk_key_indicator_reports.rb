class AddProcessedToRiskKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.boolean :processed, default: false
    end
  end
end
