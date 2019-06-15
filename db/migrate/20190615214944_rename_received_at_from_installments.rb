class RenameReceivedAtFromInstallments < ActiveRecord::Migration[5.2]
  def change
    rename_column :installments, :received_at, :finished_at
  end
end
