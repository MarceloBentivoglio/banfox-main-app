class DocumentsController < ApplicationController
  before_action :set_seller, only: [:index, :new, :create]
  before_action :set_uploads, only: [:index, :new]

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
    params.require(:seller).permit(:social_contract, :update_on_social_contract,
    :proof_of_address, :irpj, :proof_of_revenue, :sisbacen, partners_cpfs: [],
    partners_rgs: [], partners_irpfs: [], partners_proof_of_addresses: [])
  end

  def set_uploads
    @uploads = @seller.attachments
  end
end
