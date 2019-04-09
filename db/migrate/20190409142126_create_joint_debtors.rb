class CreateJointDebtors < ActiveRecord::Migration[5.2]
  def change
    create_table :joint_debtors do |t|
      t.string :name
      t.date :birthdate
      t.string :mobile
      t.string :documentation
      t.string :email
      t.references :seller, foreign_key: true

      t.timestamps
    end
  end
end
