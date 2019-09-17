class SignupController < Devise::SessionsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going

  layout "empty_layout"

  def create
    signup_params = params["signup"].permit(:email, :password, :full_name, :mobile)
    user = SignupService.call(signup_params)
    if user.new_record?
      redirect_to new_user_registration_path
    else
      sign_in user
      redirect_to how_digital_certificate_works_path
    end
  end

  def edit
  end

  def update
    seller_params = params["seller"].permit(:digital_certificate, :digital_certificate_password)
    seller = current_user.seller
    seller.set_pre_approved_initial_standard_settings
    seller.update(seller_params)
    seller.active!
    seller.pre_approved!
    redirect_to digital_certificate_finished_path
  end

end
