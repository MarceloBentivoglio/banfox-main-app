class AdjustIntallmentsToNewColumns < ActiveRecord::Migration[5.2]
  def up
    Installment.all.each do |i|
      if i.deposited_at
        i.veredict_at = i.deposited_at
        if i.paid?
          i.final_fator = i.initial_fator
          i.final_advalorem = i.initial_advalorem
          i.final_protection = i.initial_protection
          if i.operation_ended_overdue?
            i.initial_fator = i.value * (1 - 1/(1 + i.invoice.fator)**(((i.due_date - i.ordered_at.to_date).to_i + 3) / 30.0))
            i.initial_advalorem = i.value * (1 - 1/(1 + i.invoice.advalorem)**(((i.due_date - i.ordered_at.to_date).to_i + 3) / 30.0))
            i.initial_protection = i.value * i.invoice.protection_rate
          end
        end
        i.save!
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
