class AddTaxRegimeToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :tax_regime, :integer
  end
end
