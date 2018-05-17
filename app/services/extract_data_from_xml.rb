class ExtractDataFromXml
  def invoice(file)
    doc = Nokogiri::XML(file.read)
    file.rewind
    invoice = Invoice.new
    invoice = extract_invoice_general_info(doc, invoice)
    invoice = extract_installments(doc, invoice)
    invoice = extract_payer_info(doc, invoice)
    invoice = extract_seller_info(doc, invoice)
    return invoice
  end

  private

  def extract_invoice_general_info (doc, invoice)
    invoice.number = doc.search('fat nFat').text.strip
    return invoice
  end

  def extract_installments (doc, invoice)
    doc.search('dup').each do |xml_installments_info|
      i = Installment.new
      i.number = xml_installments_info.search('nDup').text.strip
      # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
      i.value = Money.new(xml_installments_info.search('vDup').text.delete("\n ."))
      i.due_date = xml_installments_info.search('dVenc').text.strip
      i.invoice = invoice
      invoice.installments.push(i)
    end
    return invoice
  end

  #TODO: split this method it is too big
  def extract_payer_info (doc, invoice)
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
        payer.neighborhood = xml_payer_info.search('xBairro').text.strip
        payer.city = xml_payer_info.search('xMun').text.strip
        payer.state = xml_payer_info.search('UF').text.strip
        payer.zip_code = xml_payer_info.search('CEP').text.strip
        payer.registration_number = xml_payer_info.search('IE').text.strip
      end
      invoice.payer = payer
      return invoice
    end
  end

  def extract_seller_info (doc, invoice)
    doc.search('emit').each do |xml_seller_info|
      cnpj = xml_seller_info.search('CNPJ').text.strip
      if Seller.exists?(cnpj: cnpj)
        seller = Seller.find_by_cnpj(cnpj)
      else
        seller = Seller.new
        seller.cnpj = cnpj
        seller.company_name = xml_seller_info.search('xNome').text.strip
        seller.company_nickname = xml_seller_info.search('xFant').text.strip
      end
      invoice.seller = seller
      return invoice
    end
  end
end
