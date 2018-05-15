class AddWhatCompanyDoesToSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :product_manufacture, :boolean, default: false
    add_column :sellers, :service_provision, :boolean, default: false
    add_column :sellers, :product_reselling, :boolean, default: false

  end
end
