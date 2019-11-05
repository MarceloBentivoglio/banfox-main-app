class SellerStepsController < ApplicationController
  skip_before_action :require_active
  skip_before_action :require_not_on_going
  before_action :check_not_fully_registered_seller
  before_action :set_user, only: [:show, :update]
  before_action :set_seller, only: [:show, :update, :finish_wizard_path]
  before_action :require_step
  # This inclusion is needed to make the wizard
  include Wicked::Wizard
  # If these steps are changed the enum in model Seller and the names of the
  # seller_steps views must change as well
  steps :basic, :company, :finantial, :partner, :consent

  layout "empty_layout"

  def show
    if step == :partner
      set_partner_eql_user
    end
    render_wizard
  end

  def update
    @seller = SellerSignupService.new(step, current_user, seller_params).call
    
    session["accessed"] = step
    return render_wizard @seller unless step == :consent

    respond_to do |format|
      format.js
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_seller
    @seller = @user.seller || Seller.new(seller_params)
  end

  def set_partner_eql_user
    @seller.full_name_partner = @seller.full_name_partner || @seller.full_name
    @seller.cpf_partner = @seller.cpf_partner || @seller.cpf
    @seller.birth_date_partner = @seller.birth_date_partner || @seller.birth_date
    @seller.mobile_partner = @seller.mobile_partner || @seller.mobile
    @seller.email_partner = @seller.email_partner || @user.email
  end

  def seller_params
    params.require(:seller).permit(:full_name, :cpf, :birth_date, :mobile, :company_name,
    :cnpj, :zip_code, :address, :address_number, :city, :state, :neighborhood, :address_comp,
    :phone, :website, :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold,
    :cost_per_unit, :debt, :contact_is_partner, :full_name_partner, :cpf_partner,
    :birth_date_partner, :mobile_partner, :email_partner, :consent) if params[:seller].present?
  end

  def finish_wizard_path
    sellers_dashboard_url
  end

  def check_not_fully_registered_seller
    if current_user&.seller&.active?
      flash[:alert] = "Você já completou essa etapa"
      redirect_to sellers_dashboard_path
    end
  end

  def require_step
    if params[:id]
      requested_step = wizard_steps.index(params[:id].to_sym)
      allowed_step = wizard_steps.index(@seller.validation_status.try(:to_sym)) || 0
      if requested_step > allowed_step + 1
        return jump_to(wizard_steps.first) unless @seller.validation_status
        jump_to(@seller.validation_status.to_sym)
      end
    end
  end
end
