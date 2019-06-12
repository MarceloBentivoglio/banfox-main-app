class RenameFinalAttributesFromInstallments < ActiveRecord::Migration[5.2]
  def change
    rename_column :installments, :final_fator_cents, :initial_fator_cents
    rename_column :installments, :final_fator_currency, :initial_fator_currency
    rename_column :installments, :final_advalorem_cents, :initial_advalorem_cents
    rename_column :installments, :final_advalorem_currency, :initial_advalorem_currency
    rename_column :installments, :final_net_value_cents, :initial_net_value_cents
    rename_column :installments, :final_net_value_currency, :initial_net_value_currency
    rename_column :installments, :final_protection_cents, :initial_protection_cents
    rename_column :installments, :final_protection_currency, :initial_protection_currency
  end
end
