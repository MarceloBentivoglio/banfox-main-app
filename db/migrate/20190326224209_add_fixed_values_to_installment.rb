class AddFixedValuesToInstallment < ActiveRecord::Migration[5.2]
  def change
    add_monetize :installments, :final_net_value
    add_monetize :installments, :final_fator
    add_monetize :installments, :final_advalorem
    add_monetize :installments, :final_protection
  end
end
