class Api::V1::OperationsController < Api::V1::BaseController
  before_action :authenticate_hmac

  def sign_document_status
    puts "------ JSON que veio ------"
    document_data = JSON.parse(request.body.read)
    puts document_data

    puts "------ Nossa transformação ------"
    document_data.deep_symbolize_keys!
    puts document_data

    puts "----- doc_key: #{document_data[:document][:key]} -----------"
    # testar escrever @operation como operation
    @operation = Operation.new

    if request.headers["Event"] == "auto_close"
      @operation = Operation.find_by_sign_document_key(document_data[:document][:key])
      @operation.signed = true
      @operation.save!
      SlackMessage.new("CHQFGD43Y", "<!channel> o contrato da *Operação #{@operation.id}* foi completamente assinado").send_now
    elsif request.headers["Event"] == "sign"
      @operation = Operation.find_by_sign_document_key(document_data[:document][:key])
      signer_email = document_data[:event][:data][:user][:email]
      new_sign_document_info = @operation.sign_document_info.deep_symbolize_keys
      new_sign_document_info[:signer_signature_keys].each do |signer_signature_key|
        if signer_signature_key[:email] == signer_email
          signer_signature_key.store(:status, "signed")
        end
      end
      @operation.sign_document_info = new_sign_document_info
      @operation.save!
    end
    # testar tirar esse authorize
    authorize @operation
    render body: {}.to_json, status: :created

  end

  private

# TODO make this work
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
