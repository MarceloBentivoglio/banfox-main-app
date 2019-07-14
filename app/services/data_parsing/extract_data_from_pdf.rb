class ExtractDataFromPdf
  attr_reader :invoice

  def initialize(file, seller)
    @file = file
    @seller = seller
    @invoice = Invoice.new(seller: @seller)
    attach_pdf_invoice
    send_pdf_to_doc_parser
    @invoice.save!
    # fazer callback no model quando doc_parser_data for creado
  end

  def attach_pdf_invoice
    @invoice.document.attach(io: File.open(@file.tempfile.path), filename: @file.original_filename)
  end

  def send_pdf_to_doc_parser
    doc_parser_ticket = JSON.parse(doc_parser_request.execute.body)
    @invoice.doc_parser_ticket = doc_parser_ticket
    @invoice.doc_parser_ref = doc_parser_ticket["id"]
  end

  def doc_parser_request
    RestClient::Request.new(
      method: :post,
      url: url,
      user: secret_api_key,
      password: "",
      payload: payload,
    )
  end

  def url
    "https://api.docparser.com/v1/document/upload/#{parser_id}"
  end

  def payload
    payload = { multipart: true, file: @file }
  end

  def parser_id
    case @seller.city
    when "são paulo"
      ENV['SAOPAULO_PARSER_ID']
    when "barueri"
      ENV['BARUERI_PARSER_ID']
    else
      SlackMessage.new("CH1KSHZ2T", "Seller id #{@seller.id} uploaded an invoice that doesn't have parser").send_now
      raise RuntimeError, 'Parser non existent'
    end
  end

  def secret_api_key
    Rails.application.credentials[:doc_parser][:secret_api_key]
  end
end
