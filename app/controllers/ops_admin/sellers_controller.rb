class OpsAdmin::SellersController < OpsAdmin::BaseController
  before_action :set_seller, only: [:edit, :update, :pre_approve, :reject, :approve]

  def index
    @sellers = Seller.active.order(company_name: :asc)
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

  def pre_approve
    # There is no problem using @seller.users.first because this action only makes sense when the seller is not yet approved and thus only have one user
    @seller.pre_approved!
    SellerMailer.welcome(@seller.users.first, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name} \n cnpj: #{@seller.cnpj} foi *manualmente pré-aprovado*").send_now
    redirect_to ops_admin_sellers_path
  end

  def reject
    # There is no problem using @seller.users.first because this action only makes sense when the seller is not yet approved and thus only have one user
    @seller.rejected!
    @seller.rejected_on_commitee!
    SellerMailer.rejected(@seller.users.first, @seller).deliver_now
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name} \n cnpj: #{@seller.cnpj} foi *manualmente rejeitado*").send_now
    redirect_to ops_admin_sellers_path
  end

  def approve
    @seller.approved!
    SlackMessage.new("CC2NP6XHN", "<!channel> #{@seller.company_name} \n cnpj: #{@seller.cnpj} foi *manualmente aprovado*").send_now
    redirect_to ops_admin_sellers_path
  end

  private

  def set_seller
    @seller = Seller.find(params[:id])
  end

  def seller_params
    params.require(:seller).permit(:fator, :advalorem, :protection, :operation_limit)
  end


end
