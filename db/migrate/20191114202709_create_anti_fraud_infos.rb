class CreateAntiFraudInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :anti_fraud_infos do |t|
      t.belongs_to :user, foreign_key: true
      t.jsonb :ip_api

      t.timestamps
    end
  end
end
