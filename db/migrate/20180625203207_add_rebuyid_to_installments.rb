class AddRebuyidToInstallments < ActiveRecord::Migration[5.2]
  def change
    add_reference :installments, :rebuy, foreign_key: true
  end
end
