class InvoicesController < ApplicationController
  before_action :set_seller, only: [:store, :opened, :history, :show, :new, :create]

  def store
    @operations = Operation.in_store(@seller)
  end

  def opened
    @operations = Operation.opened(@seller)
  end

  def history
    @operations = Operation.finished(@seller)
  end

  def new
    @invoice = Invoice.new
  end

  def create
    if params[:invoice]
      extract = ExtractDataFromXml.new
      show_message = false
      invoices = extract.invoice(params[:invoice][:xmls], @seller)
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
    @invoice = Invoice.find(params[:id])
    @invoice.destroy
    redirect_to store_invoices_path
  end

  private

  def invoice_params
    params.require(:invoice).permit(xmls: [])
  end

  def set_seller
    @seller = current_user.seller
  end

end

# Joaquims notes
# Client.where("created_at >= :start_date AND created_at <= :end_date",
#   {start_date: params[:start_date], end_date: params[:end_date]})

