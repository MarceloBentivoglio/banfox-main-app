class AddHistoricToKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.jsonb :historic
    end
  end
end
