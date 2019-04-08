class OpsAdmin::InstallmentsController < OpsAdmin::BaseController
  before_action :set_installment, only: [:approve, :reject, :deposit]
  before_action :set_seller, only: [:approve, :reject, :deposit]

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
    redirect_to ops_admin_operations_analyse_path
  end

  def reject
    @installment.rejected!
    @installment.payer_low_rated!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_analyse_path
  end

  def deposit
    @installment.opened!
    @installment.deposited!
    @installment.operation.notify_seller(@seller)
    redirect_to ops_admin_operations_deposit_path
  end


  private

  def set_installment
    @installment = Installment.find(params[:id])
  end

  def set_seller
    @seller = @installment.invoice.seller
  end
end
