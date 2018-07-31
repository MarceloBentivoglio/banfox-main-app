class IncreaseValueMoneySize < ActiveRecord::Migration[5.2]
  def change
    change_column :sellers, :monthly_revenue_cents, :integer, limit: 8
    change_column :sellers, :operation_limit_cents, :integer, limit: 8
    change_column :sellers, :monthly_fixed_cost_cents, :integer, limit: 8
    change_column :sellers, :monthly_units_sold, :integer, limit: 8
    change_column :sellers, :cost_per_unit_cents, :integer, limit: 8
    change_column :sellers, :debt_cents, :integer, limit: 8
  end
end
