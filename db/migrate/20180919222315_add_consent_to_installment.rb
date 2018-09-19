class AddConsentToInstallment < ActiveRecord::Migration[5.2]
  def change
    add_column :operations, :consent, :boolean
  end
end
