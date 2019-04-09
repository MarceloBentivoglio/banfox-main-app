class SignDocuments
  attr_reader :signature_keys
  attr_reader :sign_document_key

  def initialize(operation, seller)
    @operation = operation
    @seller = seller
    response_serialized = RestClient.post(url, body, headers)
    response = JSON.parse(response_serialized).deep_symbolize_keys
    @signature_keys = response.slice(:signature_keys)
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
    { "Content-Type" => "application/json", "X-User-Email" => "joaquim@banfox.com.br", "X-User-Token" => "dx3zDP3cY4FXs8qV12W3" }
  end


  def host
    #TODO Inserir dominio do heroku em produção
    Rails.env.development? ? "https://a71cacc1.ngrok.io" : ""
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
      fator: @operation.final_fator.format(symbol: ''),
      advalorem: @operation.final_advalorem.format(symbol: ''),
      iof: "20,65",
      iof_adicional: "60,17",
      fee: "0",
      net_value: @operation.final_net_value.format(symbol: '')
    }
  end

  def installments_content
    installments = []
    @operation.installments.each do |installment|
      invoice = installment.invoice
      payer = invoice.payer
      i = {
        payer_company_name: payer.company_name,
        registration: CNPJ.new(payer.cnpj).formatted,
        type: "DMR",
        invoice_number: invoice.number,
        number: installment.number,
        due_date: installment.due_date.strftime("%d/%m/%Y"),
        outstanding_days: installment.outstanding_days,
        value: installment.value.format(symbol: ''),
        fator_advalorem: installment.final_fator.format(symbol: ''),
        iof: "23,66",
        net_value: installment.final_net_value.format(symbol: ''),
      }
      installments << i
    end
    return installments
  end

  def signers_content
    #TODO This part has to me remande when we'll have more than one signer
    #TODO Whatch out because inject is destructive, so i have to refactor this
    birthdate = @seller.birth_date_partner
    [
      {
        name: @seller.full_name_partner,
        birthdate: birthdate.insert(2, '-').insert(5, '-').to_date.strftime("%Y-%m-%d"),
        mobile: @seller.mobile_partner,
        documentation: CPF.new(@seller.cpf_partner).formatted,
        email: @seller.email_partner,
        sign_as: ["sign", "joint_debtor"]
      }
    ]
  end
end
