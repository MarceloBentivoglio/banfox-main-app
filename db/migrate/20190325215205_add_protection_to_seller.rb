class AddProtectionToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :protection, :decimal
  end
end
