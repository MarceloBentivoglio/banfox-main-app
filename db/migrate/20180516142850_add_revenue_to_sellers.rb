class AddRevenueToSellers < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :revenue, :integer
  end
end
