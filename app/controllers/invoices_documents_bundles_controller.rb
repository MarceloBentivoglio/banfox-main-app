class InvoicesDocumentsBundlesController < ApplicationController
  before_action :set_seller, only: [:create, :analysis]
  before_action :set_last_pdf_invoice, only: [:analysis]

  # TODO Review this part
  def create
    documents_params = params[:invoices_documents_bundle]
    invoices_being_parsed = false
    if documents_params
      flash[:alert] = []
      invoices = DataParsing::CreateInvoicesFromDocuments.new(documents_params[:documents], @seller).invoices
      invoices.each do |invoice|
        if invoice.instance_of?(RuntimeError)
          flash[:alert] << 'Uma das notas que você subiu contem um CNPJ que não confere com o seu' if invoice.message == "Invoice do not belongs to seller"
          flash[:alert] << 'Um dos arquivos que você subiu não é xml nem PDF' if invoice.message == "File has not a valid type: xml, PDF"
          flash[:alert] << 'O arquivo enviado está duplicado' if invoice.message == "Duplicated xml"
          flash[:alert] << 'O arquivo enviado não é valido. Chave da NF não foi encontrada' if invoice.message == "Nf key not found"
        elsif (!invoice.doc_parser_data? && invoice.document.content_type  == "application/pdf")
          invoices_being_parsed = true
        end
      end
    else
      flash[:alert] = "É necessário ao menos subir uma nota fiscal"
    end
    if invoices_being_parsed
      SlackMessage.new("CH1KSHZ2T", "<!channel> O cliente subiu um pdf!")
      redirect_to analysis_invoices_documents_bundles_path and return
    else
      redirect_to store_installments_path and return
    end
  end

  #TODO Create a pool request and ajax solution to substitute this implementation
  def analysis
    @countdown_time = @invoice.created_at
    @redirection_url = store_installments_url
  end

  private

  def set_seller
    @seller = current_user.seller
  end

  def set_last_pdf_invoice
    @invoice = @seller.invoices.order(created_at: :desc).find do |invoice|
      invoice.document.content_type == "application/pdf"
    end
  end
end
