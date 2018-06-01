class AddStatusToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :visited, :boolean, null: false, default: false
    add_column :sellers, :analysis_status, :integer, default: 0
  end
end
