class CreateKeyIndicatorReportRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :key_indicator_report_requests do |t|
      t.jsonb :input_data
      t.integer :operation_id
      t.string :kind

      t.timestamps
    end
  end
end
