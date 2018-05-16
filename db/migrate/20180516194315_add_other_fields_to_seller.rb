class AddOtherFieldsToSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :generate_boleto, :boolean, default: false
    add_column :sellers, :generate_invoice, :boolean, default: false
    add_column :sellers, :receive_cheque, :boolean, default: false
    add_column :sellers, :receive_money_transfer, :boolean, default: false
    add_column :sellers, :company_clients, :boolean, default: false
    add_column :sellers, :individual_clients, :boolean, default: false
    add_column :sellers, :government_clients, :boolean, default: false
    add_column :sellers, :pay_up_front, :boolean, default: false
    add_column :sellers, :pay_30_60_90, :boolean, default: false
    add_column :sellers, :pay_90_plus, :boolean, default: false
    add_column :sellers, :pay_factoring, :boolean, default: false
    add_column :sellers, :permit_contact_client, :boolean, default: false
    add_column :sellers, :charge_payer, :boolean, default: false
  end
end
