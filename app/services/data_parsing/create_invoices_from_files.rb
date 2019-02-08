class CreateInvoicesFromDocuments
  def initialize(files, seller)
    @files = files
    @seller = seller
    @new_invoices = []

    @files.each do |file|
      begin
      if file_is_xml?(file)
        @new_invoices << ExtractDataFromXml.new(file, @seller)
      elsif file_is_pdf?(file)
        @new_invoices <<  ExtractDataFromPdf.new(file, @seller)
      else
        raise RuntimeError, 'File has not a valid type: xml, PDF'
      end
      rescue RuntimeError => e
        @new_invoices << e
      end
    end

    return @new_invoices
  end

  private

  def file_is_xml?(file)
    file.content_type == "text/xml"
  end

  def file_is_pdf?(file)
    file.content_type == "application/pdf"
  end

end
