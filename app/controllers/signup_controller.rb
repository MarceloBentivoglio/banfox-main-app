class SignupController < Devise::SessionsController
  skip_before_action :require_active
  skip_before_action :require_permission_to_operate
  skip_before_action :require_not_on_going

  layout "empty_layout"

  def create
    signup_params = params["signup"].permit(:email, :password, :full_name, :mobile)
    seller, user = SignupService.call(signup_params)

    if user.valid? && seller.valid?
      user.save
      seller.save

      sign_in user
      redirect_to how_digital_certificate_works_path
    else
      errors = seller.errors.messages.deep_merge(user.errors.messages)
      redirect_to new_user_registration_path, flash: errors
    end
  end

  def edit
  end

  def update
    @seller = current_user.seller
    @seller.set_pre_approved_initial_standard_settings
    @seller.auto_veredict_at = Time.current
    @seller.allowed_to_operate = true
    @seller.update(cryptographed_seller_params)
    @seller.active!
    @seller.pre_approved!

    respond_to do |format|
      format.js
    end
  end

  def digital_certificate_encrypted
    return '' if seller_params[:digital_certificate].blank?
    Base64.encode64(Security::Crypt.new(seller_params[:digital_certificate].read).encrypt)
  end

  def digital_certificate_password_encrypted
    return '' if seller_params[:digital_certificate_password].blank?
    Base64.encode64(Security::Crypt.new(seller_params[:digital_certificate_password]).encrypt)
  end

  def cryptographed_seller_params
    {
      digital_certificate_base64: digital_certificate_encrypted,
      digital_certificate_password: digital_certificate_password_encrypted
    }
  end

  def seller_params
    params["seller"].permit(:digital_certificate, :digital_certificate_password)
  end
end
