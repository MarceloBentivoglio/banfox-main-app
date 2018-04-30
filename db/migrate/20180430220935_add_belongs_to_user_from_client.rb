class AddBelongsToUserFromClient < ActiveRecord::Migration[5.1]
  def change
    add_reference(:clients, :users, foreign_key: true)
  end
end
