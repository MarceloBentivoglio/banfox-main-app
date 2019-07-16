class AddParamsToKeyIndicators < ActiveRecord::Migration[5.2]
  def change
    add_column :key_indicators, :params, :jsonb
  end
end
