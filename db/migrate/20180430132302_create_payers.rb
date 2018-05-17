class CreatePayers < ActiveRecord::Migration[5.1]
  def change
    create_table :payers do |t|
      t.string :cnpj
      t.string :company_name
      t.string :registration_number
      t.string :zip_code
      t.string :address
      t.string :address_number
      t.string :neighborhood
      t.string :state
      t.string :city
      t.timestamps
    end
  end
end
