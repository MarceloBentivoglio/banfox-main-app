class AddCorrectedNetValueCentsToInstallments < ActiveRecord::Migration[5.2]
  def change
    change_table :installments do |t|
      t.bigint :corrected_net_value_cents
    end
  end
end
