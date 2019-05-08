class ExtractDataFromJson
  attr_reader :invoice

  DATA_TEMPLATE = {
    # "id" : "2a73f08c34da2caa8902f5545b9624db",
    "authenticity_code" => "343T.8671.0842.2932099-S",
    "number" => "000245",
    "issue_date" => "2019-02-05",
    "total_value" => "4878900",
    "days_until_due" => "21",
    "payer_cnpj" => "09138393000179",
    "payer_name" => "GME AEROSPACE INDUSTRIA DE MATERIAL COMPOSTO S.A",
    "payer_address" => "ALAMEDA BOM PASTOR, 1683",
    "payer_neighborhood" => "OURO FINO",
    "payer_city" => "SAO JOSE DOS PINHAIS",
    "payer_state" => "PR",
    "payer_zipcode" => "83015140",
    "payer_email" => "eugenia.lopes@gmebrasil.com.br",
    "seller_cnpj" => "15028515000177"
  }

  def initialize(invoice_data)
    @data = invoice_data
    @invoice = Invoice.find_by_doc_parser_ref(@data["document_id"])
    set_template_value_to_empty_keys
    unless @invoice.seller
      @invoice.seller = Seller.find_by_cnpj(@data["seller_cnpj"])
    end
    invoice_attributes = {
      number: @data["number"],
      invoice_type: :service_invoice,
      issue_date: Date.parse(@data["issue_date"]),
      doc_parser_data: @data,
    }

    @i = Installment.new()
    ninety_days = 90.days.since.to_date
    @i.value = Money.new(@data["total_value"])
    @i.number = "#{@data["number"]}/01"
    @i.due_date = Date.parse(@data["issue_date"]) + @data["days_until_due"].to_i.days
    @i.backoffice_status = ((@i.due_date <= Date.current) || (@i.due_date > ninety_days)) ? :unavailable : :available
    @i.unavailability = set_unavailability(@i.due_date, ninety_days)

    payer_cnpj = @data["payer_cnpj"]
    if Payer.exists?(cnpj: payer_cnpj)
      @payer = Payer.find_by_cnpj(payer_cnpj)
    else
      payer_attributes = {
        cnpj: payer_cnpj,
        company_name: @data["payer_name"],
        address: @data["payer_address"],
        neighborhood: @data["payer_neighborhood"],
        city: @data["payer_city"],
        state: @data["payer_state"],
        zip_code: @data["payer_zipcode"],
        email: @data["payer_email"],
        fator: @invoice.seller.fator,
        advalorem: @invoice.seller.advalorem,
      }
      @payer = Payer.new(payer_attributes)
    end

    @invoice.attributes = invoice_attributes
    @invoice.payer = @payer
    @invoice.installments.push(@i)
    @invoice.save!
  end

  private

  def set_unavailability (due_date, ninety_days)
    return :due_date_past if due_date <= Date.current
    return :due_date_later_than_limit if due_date > ninety_days
    return :non_applicable
  end

  def set_template_value_to_empty_keys
    @data.each do |key, value|
       if value.empty?
          @data[key] = DATA_TEMPLATE[key]
       end
    end
  end
end


