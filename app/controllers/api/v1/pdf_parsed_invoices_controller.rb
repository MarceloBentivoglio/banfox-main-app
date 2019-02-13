class Api::V1::PdfParsedInvoicesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    invoice_data = JSON.parse(request.body.read)
    ExtractDataFromJson.new(invoice_data)
    @invoice = Invoice.new
    authorize @invoice
  end
end
