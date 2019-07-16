class RenameKeyRiskIndicatorToKeyIndicator < ActiveRecord::Migration[5.2]
  def change
    rename_table :key_risk_indicators, :key_indicators
  end
end
