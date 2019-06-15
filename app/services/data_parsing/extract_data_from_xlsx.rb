class ExtractDataFromXlsx
  def paid_invoices_importation(path, seller_cnpj)
    extract_invoices_installments(path, true, seller_cnpj)
  end

  def opened_invoices_importation(path, seller_cnpj)
    extract_invoices_installments(path, false, seller_cnpj)
  end

  def payers_importation(path)
    extract_payers(path)
  end

  private

  def extract_invoices_installments(path, paid_flag, seller_cnpj)
    data = extract_data_from_excel(path)
    data.each_with_index do |row, row_number|
      next if row_number == 0
      cols = row.values
      puts "processing line: #{row_number + 1}....................>"
      break if cols[0].nil?
      installment_attributes = {
        number: cols[0],
        due_date: paid_flag ? define_date(cols[6]) : define_date(cols[7]),
        finished_at: paid_flag ? define_date(cols[7]) : nil,
        value: paid_flag ? Money.new(treat_currency_from_file(cols[10])) : Money.new(treat_currency_from_file(cols[11])),
        liquidation_status: paid_flag ? define_liquidation_status(paid_flag, cols[17]) : 0,
        import_ref: paid_flag ? cols[16] : cols[9],
      }
      # TODO: Make it work for more than one client because the inportation_reference can be equal to different clients
      # TODO: This logic is in fact incorrect, the "AND import_ref" shouldn't exist. However, the data from smart is not trustworth. So we should use this logic for importation
      invoice =  Invoice.where("number = ? AND import_ref = ? AND created_at > ?", installment_attributes[:number].slice(0..-4), installment_attributes[:import_ref], 10.minutes.ago).first
      if invoice.nil?
        invoice_attributes = {
          number: cols[0].slice(0..-4),
          sale_date: paid_flag ? define_date(cols[9]) : define_date(cols[6]),
          seller: Seller.find_by_cnpj(seller_cnpj),
          payer: paid_flag ? Payer.where("company_name LIKE '#{cols[3]}%'").first : Payer.where("company_name LIKE '#{cols[3].slice(0..-8)}%'").first,
          import_ref: paid_flag ? cols[16] : cols[9],
        }
        invoice = Invoice.new(invoice_attributes)
        invoice.save!
        define_invoice_type(invoice, cols[2])
        invoice.deposited!
      end
      installment_attributes[:invoice] = invoice
      installment = Installment.new(installment_attributes)
      installment.save!
      operation = Operation.where("import_ref = ? AND created_at > ?", invoice.import_ref, 10.minutes.ago).first
      if operation.nil?
        operation_attributes = {
          import_ref: invoice.import_ref,
        }
        operation = Operation.new(operation_attributes)
        operation.save!
      end
      invoice.operation = operation
      invoice.save!
      puts "<........................line: #{row_number + 1} finished"
    end
  end

  def extract_payers(path)
    data = extract_data_from_excel(path)
    data.each_with_index do |row, row_number|
      next if row_number == 0
      cols = row.values
      puts "processing payer line: #{row_number + 1} ....................>"
      break if cols[0].nil?
      # TODO: Separate the address number from the address, maybe using regex
      payer_attributes = {
        import_ref: cols[0],
        company_name: cols[1],
        cnpj: clean_company_data(cols[2]),
        address: cols[3],
        zip_code: clean_company_data(cols[4]),
        city: cols[5],
        email: cols[6],
        phone: cols[7],
      }
      payer = Payer.new(payer_attributes)
      begin
      payer.save!
      puts "<.......................payer line: #{row_number + 1} finished"
      rescue
        puts "<..................../////Payer ja adicionado"
      end
    end
  end

  def extract_data_from_excel(path)
    workbook = Creek::Book.new path
    workbook.sheets.first.rows
  end

  def clean_company_data(cnpj)
    cnpj.delete! './-'
    return cnpj
  end

  def define_date(date)
    date = (Date.new(1899,12,30) + date.to_i) if date.instance_of? String
    return date
  end

  def treat_currency_from_file(string)
    string = sprintf('%.2f', string)
    string.delete! '.'
  end

  def define_liquidation_status(paid_flag, status)
    return 2 if status == "Repasse/Recompra"
    return 1
  end

  def define_invoice_type(invoice, invoice_type)
    case invoice_type
      when "CHQ"
        invoice.check!
      when "DMR"
        invoice.merchandise!
      else
        invoice.contract!
    end
  end

end
