class AddTtlToExternalData < ActiveRecord::Migration[5.2]
  def change
    change_table :external_data do |t|
      t.datetime :ttl
    end
  end
end
