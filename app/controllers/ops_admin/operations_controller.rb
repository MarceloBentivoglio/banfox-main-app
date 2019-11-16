class OpsAdmin::OperationsController < OpsAdmin::BaseController

  def analyse
    #TODO create a scope in operations
    # @seller = current_user.seller
    @operations = Operation.joins(:installments)
                           .where(installments: {backoffice_status: :ordered})
                           .preload(:installments)
                           .distinct
                           .paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def deposit
    #TODO this works only for the approved, we need to make it work for rejected as well
    #TODO create a scope in operations
    @seller = current_user.seller
    @operations = Operation.joins(:installments)
                           .where(signed: true)
                           .where(installments: {backoffice_status: :approved})
                           .preload(:installments)
                           .distinct
                           .paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def follow_up
    @operations = Operation.joins(:installments)
                           .where(signed: true)
                           .where(installments: {backoffice_status: :deposited, liquidation_status: :opened})
                           .preload(:installments)
                           .distinct
                           .paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def billing_rulers
    @billing_rulers = BillingRuler.where(status: "ready").order(:created_at)
  end

  def send_billing_mail
    safe_params = params.permit(:id, :method)
    billing_ruler = BillingRuler.find(safe_params[:id])
    seller = billing_ruler.seller
    SellerMailer.send(safe_params[:method], seller.users&.first, seller, billing_ruler.installments, billing_ruler.code).deliver_now
    billing_ruler.sent_to_seller!
    redirect_to ops_admin_operations_billing_rulers_path
  end
end
