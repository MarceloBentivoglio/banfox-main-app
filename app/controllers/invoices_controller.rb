class InvoicesController < ApplicationController
  include ApplicationHelper
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
      messages = []
      invoices = extract.invoice(params[:invoice][:xmls], @seller)
      operation = Operation.create
      invoices.each do |invoice|
        if invoice.instance_of?(RuntimeError)
          messages << invoice.message
          show_message = true
        else
          invoice.operation = operation
          invoice.save!
          invoice.traditional_invoice!
        end
      end
      operation.destroy if operation.invoices.empty?
      if show_message
        messages.each do |err_message|
          flash_message(:alert, 'Uma das notas que você subiu contem um CNPJ que não confere com o seu. As demais notas (caso haja) foram adicionadas') if err_message == "Invoice do not belongs to seller"
          flash_message(:alert, 'Um dos arquivos que você subiu não é um XML') if err_message == "File is not a xml type"
          # flash[:alert] << "Uma das notas que você subiu contem um CNPJ que não confere com o seu. As demais notas (caso haja) foram adicionadas." if err_message == "Invoice do not belongs to seller"
          # flash[:alert] << "Um dos arquivos que você subiu não é um XML" if err_message == "File is not a xml type"
        end
      end
      redirect_to store_invoices_path
    else
      flash[:alert] = "É necessário ao menos subir uma nota fiscal em XML"
      redirect_to new_invoice_path
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    authorize @invoice
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

