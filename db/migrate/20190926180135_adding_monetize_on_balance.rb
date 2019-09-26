class AddingMonetizeOnBalance < ActiveRecord::Migration[5.2]
  def change
    remove_column :balances, :paid_date, :date
    remove_column :balances, :credit, :integer
    add_monetize :balances, :value
  end
end
