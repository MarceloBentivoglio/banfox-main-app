class CreatePayers < ActiveRecord::Migration[5.1]
  def change
    create_table :payers do |t|
      t.string :cnpj
      t.string :company_name
      t.string :email
      t.string :phone
      t.string :address
      t.string :address_number
      t.string :neighborhood
      t.string :state
      t.string :city
      t.string :zip_code
      t.string :import_ref

      t.timestamps
    end
  end
end
