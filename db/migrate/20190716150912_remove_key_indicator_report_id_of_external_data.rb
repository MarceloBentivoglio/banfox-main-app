class RemoveKeyIndicatorReportIdOfExternalData < ActiveRecord::Migration[5.2]
  def change
    change_table :external_data do |t|
      t.remove :key_indicator_report_id
    end
  end
end
