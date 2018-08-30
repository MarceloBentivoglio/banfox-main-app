class AddRejMotiveToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :rej_motive, :integer
  end
end
