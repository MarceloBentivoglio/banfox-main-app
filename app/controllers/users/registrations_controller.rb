class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_active
  skip_before_action :require_not_rejected
  layout "sessions_layout"

  protected

  def after_sign_up_path_for(resource)
    '/seller_steps'
  end
end
