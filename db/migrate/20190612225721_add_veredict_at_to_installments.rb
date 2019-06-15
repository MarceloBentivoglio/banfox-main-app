class AddVeredictAtToInstallments < ActiveRecord::Migration[5.2]
  def change
    add_column :installments, :veredict_at, :datetime
  end
end
