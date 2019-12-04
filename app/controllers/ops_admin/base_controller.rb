class OpsAdmin::BaseController < ApplicationController
  before_action :authenticate_admin
  layout "ops_admin_layout"

  def authenticate_admin
    return if current_user.admin? && !current_user.kir_permission?
    redirect_to "/"
  end
end
