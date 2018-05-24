class SellerStepsController < ApplicationController
  before_action :check_not_fully_registered_seller
  # This inclusion is needed to make the wizard
  include Wicked::Wizard
  # If these steps are changed the enum in model Seller and the names of the
  # seller_steps views must change as well
  steps :basic, :company, :finantial, :client, :consent

  layout "empty_layout"

  def show
    @user = current_user
    case step
    when :basic
      if @user.seller
        @seller = @user.seller
      else
        @seller = Seller.new
      end
    else
      @seller = @user.seller
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
        @seller = @user.seller
        @seller.assign_attributes(seller_params)
      end
      # This line is necessary for the validations of fields on each step
      @seller.validation_status = step.to_s
      @user.seller = @seller
      @user.save!
    else
      @seller = @user.seller
      # This line is necessary for the validations of fields on each step
      @seller.validation_status = step.to_s
      # I had to put seller active inside the if loop because it wouldn't work
      # otherway
      if @seller.update_attributes(seller_params)
        @seller.active! if wizard_steps.last == step
      end
    end
    render_wizard @seller
  end

  private

  def seller_params
      params.require(:seller).permit(:full_name, :cpf, :phone, :company_name,
      :cnpj, :product_manufacture, :service_provision, :product_reselling,
      :company_type, :revenue, :rental_cost, :employees, :generate_boleto,
      :generate_invoice, :receive_cheque, :receive_money_transfer,
      :company_clients, :individual_clients, :government_clients, :pay_up_front,
      :pay_30_60_90, :pay_90_plus, :pay_factoring, :permit_contact_client,
      :charge_payer, :consent)
  end

  def finish_wizard_path
    invoices_path
  end
# TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def check_not_fully_registered_seller
    if current_user.seller
      if current_user.seller.active?
        flash[:error] = "Você já completou essa etapa"
        redirect_to invoices_path
      end
    end
  end

end
