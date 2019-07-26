class AddVeredictAllowedToOperateToSellers < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :auto_veredict_at, :datetime
    add_column :sellers, :veredict_at, :datetime
    add_column :sellers, :allowed_to_operate, :boolean
    add_column :sellers, :forbad_to_operate_at, :datetime
  end
end
