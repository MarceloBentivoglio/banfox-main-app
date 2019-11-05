class Api::V1::PdfParsedInvoicesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    puts "\n----> Pdf parsing start here\n\n"
    invoice_data = JSON.parse(request.body.read)
    @invoice = DataParsing::ExtractDataFromJson.new(invoice_data).invoice
    puts "\n\nPdf parsed <----\n"
    authorize @invoice
    render body: {ok: "You got here!"}.to_json, status: :created
  end
end
