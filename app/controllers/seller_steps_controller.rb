class SellerStepsController < ApplicationController
  skip_before_action :require_active
  before_action :check_not_fully_registered_seller
  # This inclusion is needed to make the wizard
  include Wicked::Wizard
  # If these steps are changed the enum in model Seller and the names of the
  # seller_steps views must change as well
  steps :basic, :finantial, :documentation, :consent

  layout "empty_layout"

  def show
    @user = current_user
    case step
    when :basic
      if @user.seller
        set_seller
      else
        @seller = Seller.new
      end
    else
      set_seller
      set_uploads
    end
    render_wizard
  end

  def update
    @user = current_user
    case step
    when :basic
      unless @user.seller
        @seller = Seller.new(seller_params)
      else
        set_seller
        @seller.assign_attributes(seller_params)
      end
      # This line is necessary for the validations of fields on each step
      @seller.validation_status = step.to_s
      @user.seller = @seller
      @user.save!
    else
      set_seller
      set_uploads
      # This line is necessary for the validations of fields on each step
      @seller.validation_status = step.to_s
      # I had to put seller active inside the if loop because it wouldn't work
      # otherway
      if @seller.update_attributes(seller_params)
        @seller.active! if wizard_steps.last == step
      end
    end
    render_wizard @seller
    rescue ActionController::ParameterMissing
      @seller.validation_status = previous_step.to_s
      render_wizard
  end

  private

  def set_seller
    @seller = @user.seller
  end

  def set_uploads
    @uploads = @seller.attachments
  end

  def seller_params
      params.require(:seller).permit(:full_name, :cpf, :phone, :company_name,
      :cnpj, :monthly_revenue, :monthly_fixed_cost, :monthly_units_sold,
      :cost_per_unit, :debt, :consent, social_contracts: [],
      update_on_social_contracts: [], address_proofs: [], irpjs: [],
      revenue_proofs: [], financial_statements: [], cash_flows: [],
      abc_clients: [], sisbacens: [], partners_cpfs: [], partners_rgs: [],
      partners_irpfs: [], partners_address_proofs: [])
  end

  def finish_wizard_path
    sellers_show_path
  end
# TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def check_not_fully_registered_seller
    if current_user.seller
      if current_user.seller.active?
        flash[:alert] = "Você já completou essa etapa"
        redirect_to sellers_show_path
      end
    end
  end
end
