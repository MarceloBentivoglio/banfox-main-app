class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going
  layout "sessions_layout"

  protected

  def after_sign_up_path_for(resource)
    '/seller_steps'
  end
end
