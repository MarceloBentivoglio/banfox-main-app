class AddRenegotiationToInstallments < ActiveRecord::Migration[5.2]
  def change
    change_table :installments do |t|
      t.boolean :renegotiation, default: false
    end
  end
end
