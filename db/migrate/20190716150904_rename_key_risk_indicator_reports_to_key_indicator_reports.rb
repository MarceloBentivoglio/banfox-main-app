class RenameKeyRiskIndicatorReportsToKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    rename_table :key_risk_indicator_reports, :key_indicator_reports
  end
end
