class AddCorrectedNetValueToInstallment < ActiveRecord::Migration[5.2]
  def change
    change_table :installments do |t|
      t.bigint :corrected_net_value
    end
  end
end
