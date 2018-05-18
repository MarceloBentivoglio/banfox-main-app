class InvoicesController < ApplicationController
  before_action :require_active

  def index
    @seller = current_user.seller
    @invoices = Invoice.includes(:seller).where(seller: @seller)
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

# TODO: refactor, I am sure that there is a smater way to write this code with less querries
  def require_active
    if current_user.seller
      unless current_user.seller.active?
        flash[:error] = "Você precisa completar seu cadastro"
        redirect_to seller_steps_path
      end
    end
  end
end
