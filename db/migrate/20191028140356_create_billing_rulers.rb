class CreateBillingRulers < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_rulers do |t|
      t.integer :billing_type
      t.integer :status
      t.string :code, unique: true
      t.references :seller, foreign_key: true

      t.timestamps
    end

    create_table :billing_rulers_installments do |t|
      t.references :billing_ruler, foreign_key: true
      t.references :installment, foreign_key: true
    end
  end
end
