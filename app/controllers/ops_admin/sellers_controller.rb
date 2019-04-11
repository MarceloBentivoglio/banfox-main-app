class OpsAdmin::SellersController < OpsAdmin::BaseController
  before_action :set_seller, only: [:edit, :update]

  def index
    @sellers = Seller.all.order(company_name: :asc)
  end

  def edit
  end

  def update
    if @seller.update(seller_params)
      redirect_to ops_admin_sellers_path
    else
      render :edit
    end
  end

  private

  def set_seller
    @seller = Seller.find(params[:id])
  end

  def seller_params
    params.require(:seller).permit(:fator, :advalorem, :protection)
  end


end
