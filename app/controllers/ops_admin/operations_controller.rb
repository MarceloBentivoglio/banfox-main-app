class OpsAdmin::OperationsController < OpsAdmin::BaseController

  def index
    @seller = current_user.seller
    @operations = Operation.joins(:installments).where(installments: {backoffice_status: :ordered}).preload(:installments).paginate(page: params[:page])
    respond_to do |format|
      format.html
      format.js
    end
  end
end
