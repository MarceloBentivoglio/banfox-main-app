class Api::V1::OperationsController < Api::V1::BaseController
  before_action :authenticate_hmac

  def sign_document_status
    puts "------ JSON que veio ------"
    document_data = JSON.parse(request.body.read)
    puts document_data

    puts "------ Nossa transformação ------"
    document_data.deep_symbolize_keys!
    puts document_data

    puts "------ to pra entrar ------"
    puts request.headers["Event"]

    puts "----- doc_key: #{document_data[:document][:key]} -----------"
    @operation = Operation.new

    if request.headers["Event"] == "auto_close"
      puts "------ entrei ------"
      #TODO Understand why the signature key is coming different from what we expected
      @operation = Operation.find_by_sign_document_key(document_data[:document][:key])
      # @operation = Operation.last
      puts "encontrei a operação"
      puts @operation
      @operation.signed = true
      @operation.save!
      puts @operation.signed
      SlackMessage.new("CHQFGD43Y", "<!channel> o contrato da *Operação #{@operation.id}* foi completamente assinado").send_now
    end
    puts "------ outra coisa antes do authorize ------"
    authorize @operation
    puts "------ outra coisa antes do render ------"
    render body: {}.to_json, status: :created

  end

  private

  def authenticate_hmac
    key = Rails.application.credentials[Rails.env.to_sym][:clicksign][:webhook_hmac_key]
    puts
    data = request.body.read
    puts "------ Our Hmac ------"
    puts mac = OpenSSL::HMAC.hexdigest("SHA256", key, data)
    puts "------ ClickSing Hmac ------"
    puts request.headers["Content-Hmac"]
  end



end
