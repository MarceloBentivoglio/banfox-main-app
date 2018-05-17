class DropUnusedTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :company_purposes
    drop_table :purposes
  end
end
