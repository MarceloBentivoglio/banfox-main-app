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
    authorize @seller
  end

  def seller_params
    params.require(:seller).permit(social_contracts: [],
      update_on_social_contracts: [], address_proofs: [], irpjs: [],
      revenue_proofs: [], sisbacens: [], partners_cpfs: [], partners_rgs: [],
      partners_irpfs: [], partners_address_proofs: [])
  end

  def set_uploads
    @uploads = @seller.attachments
  end
end
