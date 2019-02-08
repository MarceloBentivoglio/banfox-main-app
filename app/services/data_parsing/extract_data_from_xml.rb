class ExtractDataFromXml
  def initialize(file, seller)
    @file = file
    @seller = seller

    begin
    doc = Nokogiri::XML(@file.read)
    @file.rewind
    invoice = Invoice.new
    invoice = check_invoice_seller(doc, invoice, @seller)
    invoice = extract_invoice_general_info(doc, invoice)
    invoice = extract_installments(doc, invoice)
    invoice = extract_payer_info(doc, invoice, @seller)
    invoice.document.attach(io: File.open(@file.tempfile.path), filename: @file.original_filename)
    invoice.save!
    invoice.traditional_invoice!
    rescue RuntimeError => e
      return e
    end
    return invoice
  end

  private

  def extract_invoice_general_info (doc, invoice)
    invoice.number = doc.search('fat nFat').text.strip
    return invoice
  end

  def extract_installments (doc, invoice)
    ninety_days = 90.days.since.to_date
    doc.search('dup').each do |xml_installments_info|
      i = Installment.new
      i.number = xml_installments_info.search('nDup').text.strip
      # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
      i.value = Money.new(xml_installments_info.search('vDup').text.delete("\n ."))
      i.due_date = xml_installments_info.search('dVenc').text.strip
      i.invoice = invoice
      i.backoffice_status = ((i.due_date <= Date.current) || (i.due_date > ninety_days)) ? 1 : 2
      i.unavailability = set_unavailability(i.due_date, ninety_days)
      invoice.installments.push(i)
    end
    return invoice
  end

  #TODO: split this method it is too big
  def extract_payer_info (doc, invoice, seller)
    doc.search('dest').each do |xml_payer_info|
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
        payer.fator = seller.fator
        payer.advalorem = seller.advalorem
        payer.save!
      end
      invoice.payer = payer
      return invoice
    end
  end

  def check_invoice_seller (doc, invoice, seller)
    doc.search('emit').each do |xml_seller_info|
      cnpj = xml_seller_info.search('CNPJ').text.strip
      raise RuntimeError, 'Invoice do not belongs to seller' unless cnpj == seller.cnpj
      invoice.seller = seller
      return invoice
    end
  end

  def set_unavailability (due_date, ninety_days)
    return 1 if due_date <= Date.current
    return 2 if due_date > ninety_days
    return nil
  end
end
