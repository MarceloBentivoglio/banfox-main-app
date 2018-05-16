class SellerStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :company, :finantial, :client, :consent

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
      @seller = Seller.new(seller_params)
      @user.seller = @seller
      @user.save!
    else
      @seller = @user.seller
      @seller.attributes = seller_params
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
end
