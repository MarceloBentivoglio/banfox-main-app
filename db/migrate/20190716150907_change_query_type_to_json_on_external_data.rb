class ChangeQueryTypeToJsonOnExternalData < ActiveRecord::Migration[5.2]
  def up
    change_table :external_data do |t|
      t.remove :query
      t.jsonb :query
    end
  end

  def down
    change_table :external_data do |t|
      t.remove :query
      t.string :query
    end
  end
end
