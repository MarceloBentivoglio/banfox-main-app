class CreateFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :feedbacks do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :rating
      t.boolean :recommend_banfox
      t.jsonb :questions

      t.timestamps
    end
  end
end
