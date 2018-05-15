class SellerStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :company, :finantial, :client, :invoice

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
      params.require(:seller).permit(:full_name, :cpf, :phone, :company_name, :cnpj, :product_manufacture, :service_provision, :product_reselling)
  end
end

