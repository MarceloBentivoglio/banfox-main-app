class ClientsController < ApplicationController
  def new
    @client = Client.new
  end
  def create
    @client = Client.new(client_params)
    @client.user = current_user

    if @client.save
      redirect_to root_path
    else
      render :new
    end
  end
end
