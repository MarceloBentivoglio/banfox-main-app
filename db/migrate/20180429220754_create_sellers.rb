class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string   :full_name
      t.string   :cpf
      t.string   :rf_full_name
      t.string   :rf_sit_cad
      t.string   :birth_date
      t.string   :mobile
      t.string   :company_name
      t.string   :company_nickname
      t.string   :cnpj
      t.string   :phone
      t.string   :website
      t.string   :address
      t.string   :address_number
      t.string   :address_comp
      t.string   :neighborhood
      t.string   :state
      t.string   :city
      t.string   :zip_code
      t.string   :inscr_est
      t.string   :inscr_mun
      t.string   :nire
      t.integer  :company_type
      t.monetize :operation_limit
      t.decimal  :fator
      t.decimal  :advalorem
      t.monetize :monthly_revenue
      t.monetize :monthly_fixed_cost
      t.bigint   :monthly_units_sold
      t.monetize :cost_per_unit
      t.monetize :debt
      t.string   :full_name_partner
      t.string   :cpf_partner
      t.string   :rf_full_name_partner
      t.string   :rf_sit_cad_partner
      t.string   :birth_date_partner
      t.string   :mobile_partner
      t.string   :email_partner
      t.boolean  :consent
      t.integer  :validation_status
      t.boolean  :visited, null: false, default: false
      t.integer  :analysis_status, default: 0
      t.integer  :rejection_motive, default: 0

      t.timestamps
    end
  end
end
