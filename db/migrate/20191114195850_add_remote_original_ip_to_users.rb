class AddRemoteOriginalIpToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :remote_original_ip, default: nil
    end
  end
end
