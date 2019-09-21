class AddA1PasswordToSeller < ActiveRecord::Migration[5.2]
  def change
    change_table :sellers do |t|
      t.string :digital_certificate_password
    end
  end
end
