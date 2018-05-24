class InvoicesController < ApplicationController
  before_action :require_active

  def index
    render layout: "dash_layout"
    @seller = current_user.seller
    @invoices = Invoice.includes(:seller).where(seller: @seller)
  end

  def new
    render layout: "dash_layout"
    @seller = current_user.seller
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

# TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def require_active
    if (seller = current_user.seller)
      unless seller.active?
        flash[:error] = "Você precisa completar seu cadastro"
        redirect_to "#{seller_steps_path}/#{seller.validation_status}"
      end
    else
      flash[:error] = "Você precisa completar seu cadastro"
      redirect_to seller_steps_path
    end
  end
end
