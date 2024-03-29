class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :require_active
  before_action :require_permission_to_operate
  before_action :require_not_on_going
  helper_method :resource_name, :resource, :devise_mapping, :resource_class
  before_action :set_invoices_documents_bundle
  include Pundit
  after_action :verify_authorized, only: :destroy, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :action_not_authorized

  def after_sign_in_path_for(resource_or_scope)
   sellers_dashboard_path
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private
  # TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def require_active
    if (seller = current_user.seller)
      unless seller.active?
        flash[:alert] = "Você precisa completar seu cadastro"
        redirect_to "#{seller_steps_path}/#{seller.next_step}"
      end
    else
      flash[:alert] = "Você precisa completar seu cadastro"
      redirect_to seller_steps_path
    end
  end

  def require_permission_to_operate
    if (current_user.seller)
      if current_user.seller.rejected? || (current_user.seller.allowed_to_operate == false)
        redirect_to unfortune_path
      end
    end
  end

  def require_not_on_going
    if (current_user&.seller&.on_going?)
      redirect_to takeabreath_path
    end
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def action_not_authorized
    redirect_back(fallback_location: root_path)
  end

  def set_invoices_documents_bundle
    @invoices_documents_bundle = InvoicesDocumentsBundle.new()
  end
end
