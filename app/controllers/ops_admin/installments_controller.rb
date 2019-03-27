class OpsAdmin::InstallmentsController < OpsAdmin::BaseController
  before_action :set_installment, only: [:approve, :reject]
  before_action :set_seller, only: [:approve, :reject]

  def approve
    ActiveRecord::Base.transaction do
      # TODO: This values should be in fact inputs from the ops_admin/operations so that the admin can customize the operation
      @installment.final_net_value = @installment.net_value
      @installment.final_fator = @installment.fator
      @installment.final_advalorem = @installment.advalorem
      @installment.final_protection = @installment.protection
      @installment.save!
      @installment.approved!
    end
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_path
  end

  def reject
    @installment.rejected!
    @installment.payer_low_rated!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_path
  end

  private

  def set_installment
    @installment = Installment.find(params[:id])
  end

  def set_seller
    @seller = @installment.invoice.seller
  end
end
