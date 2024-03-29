class D4Sign
  TOKEN = "live_effdf56dfcdbfc106f76f92aabba5febfa3bf312fd829b16bd1c6ff8a6282e55"
  KEY = "live_crypt_EEf6XfZYARawupkF6GsRGCMlIX7znn5K"
  #WEBHOOKURL = "https://banfox.com.br/api/v1/operations/webhook_response"

  def initialize(operation, seller)
    @operation = operation
    @seller = seller
  end

  def send_document
    response = RestClient.post(url + "/create_pdf", body, headers)
    jresponse = JSON.parse(response)
    jresponse["uuid"]
  end

  def add_webhook(doc_id)
    url = "https://secure.d4sign.com.br/api/v1/documents/#{doc_id}/webhooks?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"
    headers = {
      "Content-Type": "application/json"
    }
    body = {
      "url": ENV.fetch('WEBHOOKURL')
    }
    RestClient.post(url, body, headers)
  rescue Exception => e  
    Rollbar.error(e)
    nil
  end

  def add_signer_list(doc_id, seller)
    @signers = []
    url = "https://secure.d4sign.com.br/api/v1/documents/#{doc_id}/createlist?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"
    headers = {
      "Content-Type": "application/json"
    }

    @signers << {
      "email": seller.email_partner,
      "act": "13",
      "foreign": "0",
      "certificadoicpbr": "1",
      "assinatura_presencial": "0",
    }
    seller.joint_debtors.each do |joint_debtor|
      @signers << {
        "email": joint_debtor.email,
        "act": "12",
        "foreign": "0",
        "certificadoicpbr": "0",
        "assinatura_presencial": "0",
        "embed_methodauth": "sms",
        "embed_smsnumber": "+55" + joint_debtor.mobile,
      }
    end
    @signers << {
      "email": "marcelo@banfox.com.br",
      "act": "4",
      "foreign": "0",
      "certificadoicpbr": "0",
      "assinatura_presencial": "0",
    }

    body = {
      "signers": @signers
    }.to_json

    begin
      response = RestClient.post(url, body, headers)
      signer_list = []
      json_response = JSON.parse(response.body)
      json_response["message"].map {|signer| signer_list << { key_signer: signer["key_signer"], email: signer["email"] }}
      signer_list
    rescue Exception => e
      puts e
    end
  end

  def send_to_sign(doc_id)
    url = "https://secure.d4sign.com.br/api/v1/documents/#{doc_id}/sendtosigner?tokenAPI=#{D4Sign::TOKEN}&cryptKey=#{D4Sign::KEY}"

    headers = {
      "Content-Type": "application/json"
    }

    body = {
      "message": "Bom dia. Clique no link abaixo para ser redirecionado e finalizar o processo.",
      "skip_email": "1",
      "workflow": "0",
      "tokenAPI": "#{D4Sign::TOKEN}"
    }.to_json

    begin
      response = RestClient.post(url, body, headers)
    rescue Exception => e
      puts e.response.body
    end
  end

  private

  def url
    "#{host}/api/v1/documents"
  end

  def body
    document_content = {}
    document_content[:seller] = seller_content
    document_content[:operation] = operation_content
    document_content[:installments] = installments_content
    document_content[:signers] = signers_content
    return document_content.to_json
  end

  def headers
    { "Content-Type" => "application/json",
      "X-User-Email" => Rails.application.credentials[Rails.env.to_sym][:banfox_document_app][:access_id],
      "X-User-Token" => Rails.application.credentials[Rails.env.to_sym][:banfox_document_app][:access_token]
    }
  end

  def host
    ENV.fetch('DOCAPPHOST')
  end

  def seller_content
    zipcode = @seller.zip_code
    {
      company_name: @seller.company_name,
      cnpj: CNPJ.new(@seller.cnpj).formatted,
      address: "#{@seller.address} #{@seller.address_number}",
      city: @seller.city,
      state: @seller.state,
      zip_code: zipcode.insert(5, '-'),
      email: @seller.email_partner
    }
  end

  def operation_content
    {
      id: @operation.id,
      time: @operation.created_at.iso8601,
      gross_value: @operation.total_value_approved.format(symbol: ''),
      fee: @operation.initial_fee.format(symbol: ''),
      net_value: @operation.initial_net_value.format(symbol: ''),
      deposit_today: @operation.deposit_today.format(symbol: ''),
      used_balance: @operation.used_balance.format(symbol: ''),
    }
  end

  def installments_content
    installments = []
    @operation.installments.each do |installment|
      if installment.approved?
        invoice = installment.invoice
        payer = invoice.payer
        i = {
          payer_company_name: payer.company_name,
          registration: CNPJ.new(payer.cnpj).formatted,
          type: "DMR",
          number: "#{invoice.number}/#{installment.number}",
          due_date: installment.due_date.strftime("%d/%m/%Y"),
          outstanding_days: installment.outstanding_days,
          value: installment.value.format(symbol: ''),
          fee: installment.initial_fee.format(symbol: ''),
          net_value: installment.initial_net_value.format(symbol: ''),
        }
        installments << i
      end
    end
    return installments
  end

  def signers_content
    @signers = []
    add_client_main_signer_to_signers
    add_client_joint_debtors_to_signers
    add_banfox_to_signers
    return @signers
  end

  def add_client_main_signer_to_signers
    birthdate = @seller.birth_date_partner
    @signers << {
      name: @seller.full_name_partner,
      birthdate: birthdate.insert(2, '-').insert(5, '-').to_date.strftime("%Y-%m-%d"),
      mobile: @seller.mobile_partner,
      documentation: CPF.new(@seller.cpf_partner).formatted,
      email: @seller.email_partner,
      sign_as: ["sign", "joint_debtor"]
    }
  end

  def add_client_joint_debtors_to_signers
    @seller.joint_debtors.each do |joint_debtor|
      @signers << {
        name: joint_debtor.name,
        birthdate: joint_debtor.birthdate.strftime("%Y-%m-%d"),
        mobile: joint_debtor.mobile,
        documentation: CPF.new(joint_debtor.documentation).formatted,
        email: joint_debtor.email,
        sign_as: ["joint_debtor"]
      }
    end
  end

  def add_banfox_to_signers
    @signers << {
      name: "João Vicente Conte",
      birthdate: "1991-02-05",
      mobile: Rails.env.development? ? "11995933009" : "11955550188",
      documentation: "339.430.918-13",
      email: "joao@banfox.com.br",
      sign_as: ["sign"]
    }
  end
end
