class OpsAdmin::BaseController < ApplicationController
  before_action :authenticate_admin

  def authenticate_admin
    return unless !current_user.admin?
    redirect_to root_path
  end
end
