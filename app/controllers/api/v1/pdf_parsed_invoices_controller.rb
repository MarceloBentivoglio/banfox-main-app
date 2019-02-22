class Api::V1::PdfParsedInvoicesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    puts "             "
    puts "Começa aqui"
    invoice_data = JSON.parse(request.body.read)
    @invoice = ExtractDataFromJson.new(invoice_data).invoice
    puts invoice_data
    puts "Termina aqui"
    puts "             "
    @invoice = Invoice.new()
    authorize @invoice
    render body: {ok: "You got here!"}.to_json, status: :created
  end
end
