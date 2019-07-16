class CreateEvidences < ActiveRecord::Migration[5.2]
  def change
    create_table :evidences do |t|
      t.jsonb :input_data
      t.jsonb :collected_data
      t.string :referee_name

      t.timestamps
    end
  end
end
