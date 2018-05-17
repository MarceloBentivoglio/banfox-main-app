class CreateSellers < ActiveRecord::Migration[5.1]
  def change
    create_table :sellers do |t|
      t.string :full_name
      t.string :cpf
      t.string :phone
      t.string :company_name
      t.string :company_nickname
      t.string :cnpj
      t.integer :company_type
      t.integer :revenue
      t.integer :employees
      t.integer :rental_cost
      t.boolean :product_manufacture, default: false
      t.boolean :service_provision, default: false
      t.boolean :product_reselling, default: false
      t.boolean :generate_boleto, default: false
      t.boolean :generate_invoice, default: false
      t.boolean :receive_cheque, default: false
      t.boolean :receive_money_transfer, default: false
      t.boolean :company_clients, default: false
      t.boolean :individual_clients, default: false
      t.boolean :government_clients, default: false
      t.boolean :pay_up_front, default: false
      t.boolean :pay_30_60_90, default: false
      t.boolean :pay_90_plus, default: false
      t.boolean :pay_factoring, default: false
      t.boolean :permit_contact_client, default: false
      t.boolean :charge_payer, default: false
      t.boolean :consent, default: false

      t.timestamps
    end
  end
end
