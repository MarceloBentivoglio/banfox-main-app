class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going
  after_action :persist_user_ip, only: [:create]
  layout "sessions_layout"

  protected

  def after_sign_up_path_for(resource)
    '/seller_steps'
  end

  def persist_user_ip
    current_user&.update(remote_original_ip: request.headers['HTTP_CF_CONNECTING_IP'])
    AntiFraudInfoJob.perform_later(current_user.id) unless current_user.nil?
  end
end
