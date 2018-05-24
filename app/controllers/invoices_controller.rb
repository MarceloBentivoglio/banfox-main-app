class InvoicesController < ApplicationController
  before_action :require_active

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

  private

  def invoice_params
    params.require(:invoice).permit(:xml)
  end

# TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def require_active
    if (seller = current_user.seller)
      unless seller.active?
        flash[:error] = "Você precisa completar seu cadastro"
        redirect_to "#{seller_steps_path}/#{seller.next_step}"
      end
    else
      flash[:error] = "Você precisa completar seu cadastro"
      redirect_to seller_steps_path
    end
  end
end
