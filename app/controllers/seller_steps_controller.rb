class SellerStepsController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :set_seller, only: [:show, :update]
  before_action :set_uploads, only: [:show, :update]

  skip_before_action :require_active
  before_action :check_not_fully_registered_seller
  # This inclusion is needed to make the wizard
  include Wicked::Wizard
  # If these steps are changed the enum in model Seller and the names of the
  # seller_steps views must change as well
  steps :basic, :finantial, :documentation, :consent

  layout "empty_layout"

  def show
    render_wizard
  end

  def update
    case step
    when :documentation
      @seller.try("update_attributes(seller_params)")
      if @seller.documentation_completed?
        @seller.validation_status = step.to_s
        @seller.save!
      else
        return render_wizard
      end
    else
      @seller.validation_status = step.to_s
      if @seller.update_attributes(seller_params)
        @seller.active! if wizard_steps.last == step
      end
      if step == :basic
        @user.seller = @seller
        @user.save!
      end
    end
    render_wizard @seller
  end

  private

  def set_user
    @user = current_user
  end

  def set_seller
    @seller = @user.seller || Seller.new(seller_params)
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
    partners_irpfs: [], partners_address_proofs: []) if params[:seller].present?
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
