class SignupController < Devise::SessionsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going

  layout "empty_layout"

  def create
    signup_params = params["signup"].permit(:email, :password, :full_name, :cnpj, :mobile)
    user = SignupService.call(signup_params)
    if user.new_record?
      redirect_to new_user_registration_path
    else
      sign_in user
      redirect_to how_digital_certificate_works
    end
  end

  def update
    seller_params = params["seller"].permit(:id, :file, :key)
    seller = Seller.find(seller_params[:id])
    seller.set_pre_approved_initial_standard_settings
    seller.active!
  end

end
