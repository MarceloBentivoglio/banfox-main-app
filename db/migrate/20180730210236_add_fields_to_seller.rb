class AddFieldsToSeller < ActiveRecord::Migration[5.2]
  def change
    add_monetize :sellers, :monthly_revenue
    add_monetize :sellers, :monthly_fixed_cost
    add_column :sellers, :monthly_units_sold, :integer
    add_monetize :sellers, :cost_per_unit
    add_monetize :sellers, :debt
  end
end
