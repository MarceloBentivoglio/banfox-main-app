class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def new
    @invoice = Invoice.new
  end

  def create
    if params[:invoice][:xml].present?
      @invoice = Invoice.from_file(params[:invoice][:xml])
      @invoice.save!
      @invoice.traditional_invoice!
      redirect_to invoices_path
    else
      redirect_to new_invoice_path
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:xml)
  end
end
