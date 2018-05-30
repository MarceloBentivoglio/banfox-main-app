class InvoicesController < ApplicationController

  def index
    @seller = current_user.seller
    @invoices = Invoice.includes(:seller).where(seller: @seller)
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

end
