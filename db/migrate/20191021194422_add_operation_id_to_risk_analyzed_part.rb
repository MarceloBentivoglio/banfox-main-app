class AddOperationIdToRiskAnalyzedPart < ActiveRecord::Migration[5.2]
  def change
    change_table :analyzed_parts do |t|
      t.integer :operation_id
    end
  end
end
