class Api::V1::MobileInputedInvoicesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    puts "       -*-        "
    puts "Mobile Começa aqui"
    @invoice = Invoice.new()
    doc_parser_ticket = JSON.parse(params[:ticket])
    @invoice.doc_parser_ticket = doc_parser_ticket
    @invoice.doc_parser_ref = doc_parser_ticket["id"]
    @invoice.document.attach(params[:document])
    @invoice.save!
    authorize @invoice
    puts "Mobile Termina aqui"
    puts "       -*-         "
    render body: {ok: "Mobile you did it"}.to_json, status: :created
  end
end
