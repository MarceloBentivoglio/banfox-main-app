class CreateCompanyPurposes < ActiveRecord::Migration[5.1]
  def change
    create_table :company_purposes do |t|
      t.references :seller, foreign_key: true
      t.references :purpose, foreign_key: true

      t.timestamps
    end
  end
end
