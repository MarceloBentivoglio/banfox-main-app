class DocumentsController < ApplicationController
  before_action :set_seller, only: [:index, :new, :create]

  def index
  end

  def new
  end

  def create
    @seller.update(seller_params)
    redirect_to documents_path
  end

  def destroy

  end

  private

  def set_seller
    @seller = current_user.seller
  end

  def seller_params
    params.require(:seller).permit(:social_contract)
  end
end
