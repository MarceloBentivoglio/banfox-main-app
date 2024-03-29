# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going
  # before_action :configure_sign_in_params, only: [:create]
  layout "sessions_layout"

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
