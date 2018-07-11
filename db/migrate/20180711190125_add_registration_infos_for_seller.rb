class AddRegistrationInfosForSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :zip_code, :string
    add_column :sellers, :address, :string
    add_column :sellers, :address_number, :string
    add_column :sellers, :neighborhood, :string
    add_column :sellers, :state, :string
    add_column :sellers, :city, :string
  end
end
