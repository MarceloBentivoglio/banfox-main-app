class InvoicesController < ApplicationController
  before_action :set_seller, only: [:index, :store, :opened, :history]
  def index
    # @invoices = Invoice.includes(:seller).where(seller: @seller)
  end

  def store
    @invoices = Invoice.in_store
  end

  def opened

  end

  def history

  end

  def new
    @seller = current_user.seller
    @invoice = Invoice.new
  end

  def create
    if params[:invoice]
      extract = ExtractDataFromXml.new
      begin
      @invoice = extract.invoice(params[:invoice][:xml], current_user.seller)
      @invoice.save!
      @invoice.traditional_invoice!
      redirect_to invoices_path
      rescue
        flash[:error] = "Seu CNPJ não confere com o da nota"
        redirect_to new_invoice_path
      end
    else
      flash[:error] = "É necessário ao menos subir uma nota fiscal em XML"
      redirect_to new_invoice_path
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to invoices_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(:xml)
  end

  def set_seller
    @seller = current_user.seller
  end

end

# Joaquims notes
# Client.where("created_at >= :start_date AND created_at <= :end_date",
#   {start_date: params[:start_date], end_date: params[:end_date]})

