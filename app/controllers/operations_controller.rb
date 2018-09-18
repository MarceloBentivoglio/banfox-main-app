class OperationsController < ApplicationController

  def create
    operation = Operation.new(operation_params)
    operation.save!
    redirect_to store_installments_path
  end

  def destroy
    @operation = Operation.find(params[:id])
    authorize @operation
    @operation.destroy
    redirect_to store_installments_path
  end

  private

  def operation_params
    params.require(:operation).permit(installment_ids: [])
  end


end
