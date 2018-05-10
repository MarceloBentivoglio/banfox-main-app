class ClientStepsController < ApplicationController
  include Wicked::Wizard
  steps :basic, :company, :finantial, :client

  def show
    @user = current_user
    if step == :basic
      @client = Client.new
      # @client.save!
      # @user.client = @client
      # @user.save
    else
      @client = @user.client
    end
    render_wizard
  end

  def update
    @user = current_user
    if step == :basic
      @client = Client.new(params[:client_params])
      @user.client = @client
      @user.save!
    else
      @client.attributes = params[:client_params]
    end
    render_wizard @client
  end

  private

  def client_params
      params.require(:client).permit(:full_name, :cpf, :phone, :company_name, :cnpj)
  end
end

