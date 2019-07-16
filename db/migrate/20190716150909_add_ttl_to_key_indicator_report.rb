class AddTtlToKeyIndicatorReport < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.datetime :ttl
    end
  end
end
