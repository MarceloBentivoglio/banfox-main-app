# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  admin                  :boolean          default(FALSE), not null
#  seller_id              :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(30)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :seller, optional: true
  validates :email, email: true
  validates :email, corporate_email: true
  # validates_with CorporateEmailValidator
  after_save :async_update_spreadsheet
  acts_as_token_authenticatable

  def user_attributes
    {
      id: self.id,
      seller_id: self.seller_id,
      email: self.email,
      admin: self.admin,
    }.stringify_keys
  end

  def async_update_spreadsheet
    SpreadsheetsRowSetterJob.perform_later(spreadsheet_id, worksheet_name, (self.id + 1), self.user_attributes)
  end

  def spreadsheet_id
    Rails.application.credentials[Rails.env.to_sym][:google_spreadsheet_id]
  end

  def worksheet_name
    Rails.application.credentials[:google][:google_user_worksheet_name]
  end
end
