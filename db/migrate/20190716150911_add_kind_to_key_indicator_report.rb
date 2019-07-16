class AddKindToKeyIndicatorReport < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.string :kind
    end
  end
end
