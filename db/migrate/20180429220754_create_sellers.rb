class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :full_name
      t.string :cpf
      t.string :phone
      t.string :company_name
      t.string :company_nickname
      t.string :cnpj
      t.monetize :operation_limit
      t.monetize :monthly_revenue
      t.monetize :monthly_fixed_cost
      t.bigint :monthly_units_sold
      t.monetize :cost_per_unit
      t.monetize :debt
      t.string :address
      t.string :address_number
      t.string :neighborhood
      t.string :state
      t.string :city
      t.string :zip_code
      t.boolean :consent
      t.integer :validation_status
      t.integer :analysis_status, default: 0
      t.boolean :visited, null: false, default: false

      t.timestamps
    end
  end
end
