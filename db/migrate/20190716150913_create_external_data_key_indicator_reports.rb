class CreateExternalDataKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    create_table :external_data_key_indicator_reports, id: false do |t|
      t.integer :external_datum_id
      t.integer :key_indicator_report_id
    end

    add_index :external_data_key_indicator_reports,
              [:external_datum_id, :key_indicator_report_id],
              name: 'external_data_key_indicator_report'
  end
end
