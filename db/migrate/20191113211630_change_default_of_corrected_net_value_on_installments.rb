class ChangeDefaultOfCorrectedNetValueOnInstallments < ActiveRecord::Migration[5.2]
  def change
    change_table :installments do |t|
      t.remove :corrected_net_value
    end

    change_column_default :installments, :corrected_net_value_cents, from: nil, to: 0
  end
end
