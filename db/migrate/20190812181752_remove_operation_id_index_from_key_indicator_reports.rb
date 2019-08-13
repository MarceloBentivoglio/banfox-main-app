class RemoveOperationIdIndexFromKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    remove_index :key_indicator_reports, name: "index_key_indicator_reports_on_operation_id"
  end
end
