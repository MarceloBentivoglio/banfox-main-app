class AddKeyIndicatorReportRequestIdToKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.belongs_to :key_indicator_report_request
    end
  end
end
