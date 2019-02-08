class InvoicesDocumentsBundlesController < ApplicationController
  before_action :set_seller, only: [:create]

  # Review this part
  def create
    if params[:invoices_documents_bundle]
      extract = ExtractDataFromXml.new
      flash[:alert] = []
      invoices = extract.invoice(params[:invoices_documents_bundle][:documents], @seller)
      invoices.each do |invoice|
        if invoice.instance_of?(RuntimeError)
          flash[:alert] << 'Uma das notas que você subiu contem um CNPJ que não confere com o seu. As demais notas (caso haja) foram adicionadas' if invoice.message == "Invoice do not belongs to seller"
          flash[:alert] << 'Um dos arquivos que você subiu não é um XML' if invoice.message == "File is not a xml type"
        else
          invoice.save!
          invoice.traditional_invoice!
        end
      end
      redirect_to store_installments_path
    else
      flash[:alert] = "É necessário ao menos subir uma nota fiscal em XML"
      redirect_to store_installments_path
    end
  end

  private

  def set_seller
    @seller = current_user.seller
  end

end
