class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :full_name
      t.string :cpf
      t.string :phone
      t.string :company_name
      t.string :cnpj

      t.timestamps
    end
  end
end
