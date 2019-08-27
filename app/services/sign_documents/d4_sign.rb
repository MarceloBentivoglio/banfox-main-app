class D4Sign
  SANDTOKEN = "live_e29a3eb16705ad1125e740596478c6c5d93644fe72fbad587d00103fc1c067d1"
  SANDKEY = "live_crypt_y0hl7arZp0KBSAH1K1AiaUZ4w4uHqsIe"
  SANDSAFEID = "fbc618e4-ed7e-4a87-b7d7-bc59a9477ce6"

  def initialize(operation, seller)
    @operation = operation
    @seller = seller
    url2 = "localhost:4000/api/v1/documents"
    response = RestClient.post(url2 + "/create_pdf", body, headers)
    puts response
  end

  def self.upload_document
    url = "http://demo.d4sign.com.br/api/v1/documents/#{D4Sign::SANDSAFEID}/upload?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"
    
    headers = {
      "Content-Type": "multipart/form-data;",
      "tokenAPI": "#{D4Sign::SANDTOKEN}"
    }
    body = {
      "file": File.new("/home/furuchooo/Downloads/venc_2019_05_09.pdf", "rb"),
    }
    response = RestClient.post(url, body, headers)
    puts response
  end

  def self.get_document(doc_id)
    url = "http://demo.d4sign.com.br/api/v1/documents/#{doc_id}?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"

    response = RestClient.get(url)
    puts response
  end

  def self.add_signer_list(doc_id, seller)
    @signers = []
    url = "http://demo.d4sign.com.br/api/v1/documents/#{doc_id}/createlist?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"
    headers = {
      "Content-Type": "application/json"
    }
    
    @signers << {
      "email": seller.email_partner,
      "act": "1",
      "foreign": "0",
      "certificadoicpbr": "1",
      "assinatura_presencial": "0",
    }
    seller.joint_debtors.each do |joint_debtor|
      @signers << {
        "email": joint_debtor.email,
        "act": "8",
        "foreign": "0",
        "certificadoicpbr": "0",
        "assinatura_presencial": "0",
      }
    end
    @signers << {
      "email": "joao@banfox.com.br",
      "act": "1",
      "foreign": "0",
      "certificadoicpbr": "1",
      "assinatura_presencial": "0",
    }

    body = {
      "signers": @signers
    }.to_json

    begin
      response = RestClient.post(url, body, headers)
    rescue Exception => e
      puts e.response.body
    end
    puts response.body
  end

  def self.send_to_sign(doc_id)
    url = "http://demo.d4sign.com.br/api/v1/documents/#{doc_id}/sendtosigner?tokenAPI=#{D4Sign::SANDTOKEN}&cryptKey=#{D4Sign::SANDKEY}"

    headers = {
      "Content-Type": "application/json"
    }

    body = {
    "message": "Bom dia. Clique no link abaixo para ser redirecionado e finalizar o processo.",
    "skip_email": "0",
    "workflow": "0",
    "tokenAPI": "#{D4Sign::SANDTOKEN}"
    }.to_json

    begin
      response = RestClient.post(url, body, headers)
    rescue Exception => e
      puts e.response.body
    end
    puts response.body
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
      first_deposit: @operation.initial_deposit_today.format(symbol: ''),
      protection: @operation.initial_protection.format(symbol: ''),
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
          first_deposit: installment.first_deposit_amount.format(symbol: ''),
          protection: installment.initial_protection.format(symbol: ''),
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
      mobile: Rails.env.development? ? "11998308090" : "11955550188",
      documentation: "339.430.918-13",
      email: "joao@banfox.com.br",
      sign_as: ["sign"]
    }
  end
end
