class RemoveNetValueColumnFromInstallments < ActiveRecord::Migration[5.2]
  def change
    remove_column :installments, :initial_net_value_cents
    remove_column :installments, :initial_net_value_currency
  end
end
