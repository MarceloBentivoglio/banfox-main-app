class AddFeeToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :fator, :decimal
    add_column :sellers, :advalorem, :decimal
    add_column :payers, :fator, :decimal
    add_column :payers, :advalorem, :decimal
  end
end
