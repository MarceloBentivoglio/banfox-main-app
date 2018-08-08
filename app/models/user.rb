class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :seller, optional: true
  validates :email, presence: true, email: true

  after_save :async_update_spreadsheet

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
