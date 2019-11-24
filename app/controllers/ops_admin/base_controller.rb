class OpsAdmin::BaseController < ApplicationController
  before_action :authenticate_admin
  layout "ops_admin_layout"

  def authenticate_admin
    return unless !current_user.admin?
    redirect_to "/"
  end
end
