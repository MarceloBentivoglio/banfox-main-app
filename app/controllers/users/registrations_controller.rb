class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_active
  protected

  layout "sessions_layout"

  def after_sign_up_path_for(resource)
    '/seller_steps'
  end
end
