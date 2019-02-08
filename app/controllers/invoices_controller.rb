class InvoicesController < ApplicationController
  def destroy
    @invoice = Invoice.find(params[:id])
    authorize @invoice
    @invoice.destroy
    redirect_to store_installments_path
  end
end

