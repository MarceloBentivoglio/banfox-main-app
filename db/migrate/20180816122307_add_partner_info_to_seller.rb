class AddPartnerInfoToSeller < ActiveRecord::Migration[5.2]
  def change
    add_column :sellers, :full_name_partner, :string
    add_column :sellers, :cpf_partner, :string
    add_column :sellers, :birth_date, :string
    add_column :sellers, :birth_date_partner, :string
    add_column :sellers, :mobile, :string
    add_column :sellers, :mobile_partner, :string
    add_column :sellers, :email_partner, :string
    add_column :sellers, :contact_is_partner, :boolean
    add_column :sellers, :website, :string
  end
end
