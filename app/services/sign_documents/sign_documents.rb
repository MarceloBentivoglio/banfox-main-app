class SignDocuments
  attr_reader :sign_document_info
  attr_reader :sign_document_key

  def initialize(operation, seller)
    @operation = operation
    @seller = seller
    response_serialized = RestClient.post(url, body, headers)
    response = JSON.parse(response_serialized).deep_symbolize_keys
    puts "*** Essa é a resposta que volta da API de documentos: #{response}"
    @sign_document_info = response.slice(:signer_signature_keys)
    @sign_document_key = response[:document_key]
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
    Rails.application.credentials[Rails.env.to_sym][:banfox_document_app][:access_host]
  end

  def seller_content
    #TODO Whatch out because inject is destructive, so i have to refactor this
    zipcode = @seller.zip_code
    {
      company_name: @seller.company_name,
      cnpj: CNPJ.new(@seller.cnpj).formatted,
      address: "#{@seller.address} #{@seller.address_number}" ,
      city: @seller.city,
      state: @seller.state,
      zip_code: zipcode.insert(5, '-'),
    }
  end

  def operation_content
    {
      id: @operation.id,
      time: @operation.created_at.iso8601,
      gross_value: @operation.total_value_approved.format(symbol: ''),
      fee: @operation.final_fee.format(symbol: ''),
      net_value: @operation.final_net_value.format(symbol: ''),
      first_deposit: @operation.final_deposit_today.format(symbol: ''),
      protection: @operation.final_protection.format(symbol: ''),
    }
  end

  def installments_content
    installments = []
    @operation.installments.each do |installment|
      payer = installment.invoice.payer
      i = {
        payer_company_name: payer.company_name,
        registration: CNPJ.new(payer.cnpj).formatted,
        type: "DMR",
        number: installment.number,
        due_date: installment.due_date.strftime("%d/%m/%Y"),
        outstanding_days: installment.outstanding_days,
        value: installment.value.format(symbol: ''),
        fee: installment.fee.format(symbol: ''),
        net_value: installment.final_net_value.format(symbol: ''),
        first_deposit: installment.first_deposit_amount.format(symbol: ''),
        protection: installment.protection.format(symbol: ''),
      }
      installments << i
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
      name: "João Vicente Conte",
      birthdate: "1991-02-05",
      mobile: Rails.env.development? ? "11998308090" : "11955550188",
      documentation: "339.430.918-13",
      email: "joao@banfox.com.br",
      sign_as: ["sign"]
    }
  end
end
