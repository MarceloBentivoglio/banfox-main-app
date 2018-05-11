class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :full_name
      t.string :cpf
      t.string :phone
      t.string :company_name
      t.string :cnpj

      t.timestamps
    end
  end
end
