class AddCostToSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :rental_cost, :integer
    add_column :sellers, :employees, :integer
  end
end
