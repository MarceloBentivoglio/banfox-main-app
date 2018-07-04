class InstallmentsController < ApplicationController

  def destroy
    @installment = Installment.find(params[:id])
    authorize @installment
    @installment.destroy
    redirect_to store_invoices_path
  end
end
