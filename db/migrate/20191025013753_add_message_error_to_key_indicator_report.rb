class AddMessageErrorToKeyIndicatorReport < ActiveRecord::Migration[5.2]
  def change
    change_table :key_indicator_reports do |t|
      t.text :processing_error_message
      t.boolean :with_error, default: false
    end
  end
end
