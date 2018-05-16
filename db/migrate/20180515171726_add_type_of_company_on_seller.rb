class AddTypeOfCompanyOnSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :company_type, :integer
  end
end
