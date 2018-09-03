class AddRfNamesToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :rf_full_name, :string
    add_column :sellers, :rf_sit_cad, :string
    add_column :sellers, :rf_partner_full_name, :string
    add_column :sellers, :rf_partner_sit_cad, :string
  end
end
