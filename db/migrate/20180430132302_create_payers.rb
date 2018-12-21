class CreatePayers < ActiveRecord::Migration[5.1]
  def change
    create_table :payers do |t|
      t.string  :company_name
      t.string  :cnpj
      t.string  :inscr_est
      t.string  :inscr_mun
      t.string  :nire
      t.integer :company_type
      t.string  :email
      t.string  :phone
      t.string  :address
      t.string  :address_number
      t.string  :address_comp
      t.string  :neighborhood
      t.string  :state
      t.string  :city
      t.string  :zip_code
      t.string  :import_ref
      t.decimal :fator
      t.decimal :advalorem

      t.timestamps
    end
  end
end
