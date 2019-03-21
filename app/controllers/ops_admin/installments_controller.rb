class OpsAdmin::InstallmentsController < OpsAdmin::BaseController
  before_action :set_installment, only: [:approve, :reject]
  before_action :set_seller, only: [:approve, :reject]

  def index
    @seller = current_user.seller
    @installments = Installment.ordered.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def approve
    @installment.approved!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_installments_path
  end

  def reject
    @installment.rejected!
    @installment.payer_low_rated!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_installments_path
  end

  private

  def set_installment
    @installment = Installment.find(params[:id])
  end

  def set_seller
    @seller = @installment.invoice.seller
  end
end
