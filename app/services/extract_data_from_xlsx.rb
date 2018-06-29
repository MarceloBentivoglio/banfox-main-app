class ExtractDataFromXlsx
  def paid_invoices_importation(path)
    extract_invoices_installments(path, true)
  end

  def opened_invoices_importation(path)
    extract_invoices_installments(path, false)
  end

  def payers_importation(path)
    extract_payers(path)
  end

  private

  def extract_invoices_installments(path, paid_flag)
    data = extract_data_from_excel(path)
    data.each_with_index do |row, row_number|
      next if (0 .. 2).include? row_number
      cols = row.values
      puts "invoice/inst. line: #{row_number + 1}"
      break if cols[0].nil?
      # Right now we don't want operations that has rebuys, créditos ou pendencias
      next if paid_flag && (cols[16].include? "Repasse/Recompra")
      # This line can be used in case where the xlsx file does not carry the seller's identification number
      # seller: Seller.where("company_name LIKE '#{cols[3]}%'").first,
      installment_attributes = {
        number: cols[0],
        due_date: paid_flag ? DateTime.parse(cols[6]) : DateTime.parse(cols[7]),
        receipt_date: paid_flag ? DateTime.parse(cols[7]) : nil,
        deposit_date: paid_flag ? DateTime.parse(cols[9]) : DateTime.parse(cols[6]),
        value: paid_flag ? Money.new(treat_currency_from_file(cols[10])) : Money.new(treat_currency_from_file(cols[11])),
        paid: paid_flag,
        importation_reference: paid_flag ? cols[15] : cols[9],
      }
      # TODO: Make it work for more than one client because the inportation_reference can be equal to different clients
      # TODO: This logic is in fact incorrect, the "AND importation_reference" shouldn't exist. However, the data from smart is not trustworth. So we should use this logic for importation
      if Invoice.where("number = ? AND importation_reference = ?", installment_attributes[:number].slice(0..-4), installment_attributes[:importation_reference]).exists?
        installment_attributes[:invoice] = Invoice.where("number = ? AND importation_reference = ?", installment_attributes[:number].slice(0..-4), installment_attributes[:importation_reference]).first
      else
        invoice_attributes = {
          number: cols[0].slice(0..-4),
          seller: Seller.where("company_name LIKE '#{cols[4]}%'").first,
          payer: paid_flag ? Payer.where("company_name LIKE '#{cols[3]}%'").first : Payer.where("company_name LIKE '#{cols[3].slice(0..-8)}%'").first,
          operation: paid_flag ? Operation.find_by_importation_reference(cols[15]) : Operation.find_by_importation_reference(cols[9]),
          importation_reference: paid_flag ? cols[15] : cols[9],
        }
        invoice = Invoice.new(invoice_attributes)
        invoice.save!
        define_invoice_type(invoice, cols[2])
        invoice.deposited!
        installment_attributes[:invoice] = invoice
      end
      installment = Installment.new(installment_attributes)
      installment.save!
    end
    Invoice.all.each do |invoice|
      invoice.total_value = invoice.installments.reduce(Money.new(0)) {|total_value, installment| total_value + installment.value}
      invoice.save!
      puts "valor da invoice #{invoice.id} calculado com sucesso!"
    end
  end

  def extract_payers(path)
    data = extract_data_from_excel(path)
    data.each_with_index do |row, row_number|
      next if (0 .. 2).include? row_number
      cols = row.values
      puts "payer line: #{row_number + 1}"
      break if cols[0].nil?
      # TODO: Separate the address number from the address, maybe using regex
      payer_attributes = {
        company_name: cols[1],
        company_nickname: cols[1][0,15],
        identification_number: clean_company_identification_number(cols[2]),
        address: cols[3],
        zip_code: cols [4],
        city: cols[5],
        email: cols[6],
        phone_number: cols[7]
      }
      payer = Payer.new(payer_attributes)
      payer.save!
    end
  end

  def extract_data_from_excel(path)
    workbook = Creek::Book.new path
    workbook.sheets.first.rows
  end

  def clean_company_identification_number(cnpj)
    cnpj.delete! './-'
    return cnpj
  end

  # def treat_float_from_file(string)
  #   string
  # end

  def treat_currency_from_file(string)
    string = sprintf('%.2f', string)
    string.delete! '.'
  end

  def define_invoice_type(invoice, invoice_type)
    case invoice_type
      when "CHQ"
        invoice.check!
      when "DMR"
        invoice.traditional_invoice!
      else
        invoice.contract!
    end
  end

end
