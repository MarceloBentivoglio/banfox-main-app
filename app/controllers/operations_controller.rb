class OperationsController < ApplicationController

  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy
    redirect_to store_invoices_path
  end
end
