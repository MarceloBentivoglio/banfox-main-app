class CreateInstallments < ActiveRecord::Migration[5.1]
  def change
    create_table   :installments do |t|
      t.string     :number
      t.monetize   :value
      t.monetize   :final_net_value
      t.monetize   :final_fator
      t.monetize   :final_advalorem
      t.monetize   :final_protection
      t.date       :due_date
      t.datetime   :ordered_at
      t.datetime   :deposited_at
      t.datetime   :received_at
      t.integer    :backoffice_status, default: 0
      t.integer    :liquidation_status, default: 0
      t.integer    :unavailability, default: 0
      t.integer    :rejection_motive, default: 0
      t.string     :import_ref
      t.references :invoice, index: true, foreign_key: true
      t.references :operation, index: true, foreign_key: true

      t.timestamps
    end
  end
end
