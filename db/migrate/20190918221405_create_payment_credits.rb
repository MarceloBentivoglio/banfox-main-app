class CreatePaymentCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_credits do |t|
      t.references :installment
      t.integer :credit
      t.date :paid_date
      t.references :seller

      t.timestamps
    end
  end
end
