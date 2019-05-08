class ExtractDataFromXml
  attr_reader :invoice

  def initialize(file, seller)
    @file = file
    @seller = seller
    @invoice = Invoice.new
    @doc = Nokogiri::XML(@file.read)

    begin
    @file.rewind
    check_invoice_seller
    extract_invoice_general_info
    extract_installments
    extract_payer_info
    @invoice.document.attach(io: File.open(@file.tempfile.path), filename: @file.original_filename)
    @invoice.save!
    @invoice.merchandise_invoice!
    rescue RuntimeError => e
      @invoice = e
    end
  end

  private

  def extract_invoice_general_info
    @invoice.number = @doc.search('fat nFat').text.strip
  end

  def extract_installments
    ninety_days = 90.days.since.to_date
    @doc.search('dup').each do |xml_installments_info|
      i = Installment.new
      i.number = xml_installments_info.search('nDup').text.strip
      # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
      i.value = Money.new(xml_installments_info.search('vDup').text.delete("\n ."))
      i.due_date = xml_installments_info.search('dVenc').text.strip
      i.invoice = @invoice
      # TODO: change 1 and 2 for the status
      i.backoffice_status = ((i.due_date <= Date.current) || (i.due_date > ninety_days)) ? 1 : 2
      i.unavailability = set_unavailability(i.due_date, ninety_days)
      @invoice.installments.push(i)
    end
  end

  #TODO: split this method it is too big
  def extract_payer_info
    @doc.search('dest').each do |xml_payer_info|
      cnpj = xml_payer_info.search('CNPJ').text.strip
      if Payer.exists?(cnpj: cnpj)
        payer = Payer.find_by_cnpj(cnpj)
      else
        payer = Payer.new
        payer.cnpj = cnpj
        payer.company_name = xml_payer_info.search('xNome').text.strip
        payer.address = xml_payer_info.search('xLgr').text.strip
        payer.address_number = xml_payer_info.search('nro').text.strip
        payer.address_comp = xml_payer_info.search('xCpl').text.strip
        payer.neighborhood = xml_payer_info.search('xBairro').text.strip
        payer.city = xml_payer_info.search('xMun').text.strip
        payer.state = xml_payer_info.search('UF').text.strip
        payer.zip_code = xml_payer_info.search('CEP').text.strip
        payer.inscr_est = xml_payer_info.search('IE').text.strip
        payer.inscr_mun = xml_payer_info.search('IM').text.strip
        payer.fator = @seller.fator
        payer.advalorem = @seller.advalorem
        payer.save!
      end
      @invoice.payer = payer
    end
  end

  def check_invoice_seller
    @doc.search('emit').each do |xml_seller_info|
      cnpj = xml_seller_info.search('CNPJ').text.strip
      raise RuntimeError, 'Invoice do not belongs to seller' unless cnpj == @seller.cnpj
      @invoice.seller = @seller
    end
  end

  def set_unavailability (due_date, ninety_days)
    return 1 if due_date <= Date.current
    return 2 if due_date > ninety_days
    return nil
  end
end
