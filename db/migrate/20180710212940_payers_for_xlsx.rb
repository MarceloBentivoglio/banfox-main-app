class PayersForXlsx < ActiveRecord::Migration[5.2]
  def change
    remove_column :payers, :registration_number, :string
    add_column :payers, :email, :string
    add_column :payers, :phone, :string
  end
end
