class ExtractDataFromJson
  attr_reader :invoice

  def initialize(invoice_data)
    @data = invoice_data
    @invoice = Invoice.find_by_doc_parser_ref(@data["document_id"])
    unless @invoice.seller
      @invoice.seller = Seller.find_by_cnpj(@data["seller_cnpj"])
    end
    invoice_attributes = {
      number: @data["number"],
      invoice_type: :service,
      issued_at: Time.parse(@data["issued_at"]),
      doc_parser_data: @data,
    }

    @i = Installment.new()
    ninety_days = 90.days.since.to_date
    @i.value = Money.new(@data["total_value"])
    @i.number = "1"
    if @data["days_until_due"].present?
      @i.due_date = Time.parse(@data["issued_at"]) + @data["days_until_due"].to_i.days
      @i.backoffice_status = ((@i.due_date <= Date.current) || (@i.due_date > ninety_days)) ? :unavailable : :available
      @i.unavailability = set_unavailability(@i.due_date, ninety_days)
    else
      @i.backoffice_status = :lacking_information
    end

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
    return :unavailability_non_applicable
  end

end


