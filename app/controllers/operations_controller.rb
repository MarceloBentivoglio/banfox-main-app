class OperationsController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history, :show]
  before_action :verify_owner_of_invoice, only: [:show]

  def show
    # @installments = @invoice.installments
  end

  def store
    @operations = Operation.in_store(@seller)
  end

  def opened
    opened_operations = Operation.opened(@seller)
    overdue_operations = Operation.overdue(@seller)
    @operations = overdue_operations + opened_operations
  end

  def history
    paid_operations = Operation.paid(@seller)
    rebought_operations = Operation.rebought(@seller)
    lost_operations = Operation.lost(@seller)
    @operations = paid_operations + rebought_operations + lost_operations
  end

  def new
    @seller = current_user.seller
    @invoice = Invoice.new
  end

  def create
    if params[:invoice]
      extract = ExtractDataFromXml.new
      show_message = false
      invoices = extract.invoice(params[:invoice][:xmls], current_user.seller)
      operation = Operation.create
      invoices.each do |invoice|
        if invoice.instance_of?(RuntimeError)
        show_message = true
        else
          invoice.operation = operation
          invoice.save!
          invoice.traditional_invoice!
        end
      end
      operation.destroy if operation.invoices.empty?
      flash[:error] = "Uma das notas que você subiu contem um CNPJ que não confere com o seu. As demais notas (caso haja) foram adicionadas." if show_message
      redirect_to store_invoices_path
    else
      flash[:error] = "É necessário ao menos subir uma nota fiscal em XML"
      redirect_to new_invoice_path
    end
  end

  def destroy
    @operation = Operation.find(params[:id])
    @operation.destroy
    redirect_to store_operations_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(xmls: [])
  end

  def set_seller
    @seller = current_user.seller
  end
# TODO fazer com PUNDIT
  def verify_owner_of_invoice
    @invoice = Invoice.find(params[:id])
    redirect_to store_invoices_path if !@seller.invoices.include?(@invoice)
  end
end
