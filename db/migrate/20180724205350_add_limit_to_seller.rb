class AddLimitToSeller < ActiveRecord::Migration[5.2]
  def change
    add_monetize :sellers, :operation_limit, default: 0
  end
end
