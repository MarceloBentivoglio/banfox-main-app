class AddDigitalCertificateBase64ToSellers < ActiveRecord::Migration[5.2]
  def change
    change_table :sellers do |t|
      t.text :digital_certificate_base64
    end
  end
end
