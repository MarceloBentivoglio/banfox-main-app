class OpsAdmin::InstallmentsController < OpsAdmin::BaseController

  def approve
    installment = Installment.find(params[:id])
    installment.approved!
    redirect_to ops_admin_installments_path
  end

  def reject
    installment = Installment.find(params[:id])
    installment.rejected!
    installment.payer_low_rated!
    redirect_to ops_admin_installments_path
  end

  def index
    @seller = current_user.seller
    @installments = Installment.ordered.paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
