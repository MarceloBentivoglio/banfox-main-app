class RemovePaymentCredits < ActiveRecord::Migration[5.2]
  def change
    drop_table :payment_credits
  end
end
