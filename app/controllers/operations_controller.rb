class OperationsController < ApplicationController

  def destroy
    @operation = Operation.find(params[:id])
    authorize @operation
    @operation.destroy
    redirect_to store_invoices_path
  end
end
