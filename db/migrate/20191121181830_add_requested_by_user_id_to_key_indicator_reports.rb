class AddRequestedByUserIdToKeyIndicatorReports < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.integer :requested_by_user_id, null: true
    end
  end
end
