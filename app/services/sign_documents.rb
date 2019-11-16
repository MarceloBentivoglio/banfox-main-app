class SignDocuments
  attr_reader :sign_document_info
  attr_reader :sign_document_key

  #TODO inplement logger
  def initialize(operation, seller)
    @operation = operation
    @seller = seller
  end

  def call
    response = http_call
    puts "*** Essa é a resposta que volta da API de documentos: #{response}"
    @sign_document_info = response.slice(:signer_signature_keys)
    @sign_document_key = response[:document_key]
  end

  def http_call
    response_serialized = RestClient.post(url, body, headers)
    JSON.parse(response_serialized).deep_symbolize_keys
  end

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

  #TODO Create serializers
  def seller_content
    #TODO Whatch out because inject is destructive, so i have to refactor this
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
    #TODO Whatch out because inject is destructive, so i have to refactor this
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
      name: "Marcelo Bentivoglio",
      birthdate: "1991-02-05",
      mobile: Rails.env.development? ? "11998308090" : "11986898969",
      documentation: "339.430.918-13",
      email: "marcelo@banfox.com.br",
      sign_as: ["sign"]
    }
  end
end
