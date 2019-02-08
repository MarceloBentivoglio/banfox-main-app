class InvoicesDocumentsBundlesController < ApplicationController
  before_action :set_seller, only: [:create]

  # Review this part
  def create
    files = params[:invoices_documents_bundle][:documents]
    if files
      flash[:alert] = []
      invoices = CreateInvocesFromFiles.new(files, @seller)
      invoices.each do |invoice|
        if invoice.instance_of?(RuntimeError)
          flash[:alert] << 'Uma das notas que você subiu contem um CNPJ que não confere com o seu' if invoice.message == "Invoice do not belongs to seller"
          flash[:alert] << 'Um dos arquivos que você subiu não é xml nem PDF' if invoice.message == "File has not a valid type: xml, PDF"
        end
      end
    else
      flash[:alert] = "É necessário ao menos subir uma nota fiscal"
    end
    redirect_to store_installments_path
  end

  private

  def set_seller
    @seller = current_user.seller
  end
end
