class AddAcceptButtonToSeller < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :consent, :boolean, default: false
  end
end
