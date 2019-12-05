class AddKirPermissionToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.boolean :kir_permission, default: false
    end
  end
end
