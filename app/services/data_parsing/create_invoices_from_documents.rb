class CreateInvoicesFromDocuments
  attr_reader :invoices

  def initialize(files, seller)
    @files = files
    @seller = seller
    @invoices = []

    @files.each do |file|
      begin
      if file_is_xml?(file)
        @invoices << ExtractDataFromXml.new(file, @seller)
      elsif file_is_pdf?(file)
        @invoices <<  ExtractDataFromPdf.new(file, @seller).invoice
      else
        raise RuntimeError, 'File has not a valid type: xml, PDF'
      end
      rescue RuntimeError => e
        @invoices << e
      end
    end
  end

  private

  def file_is_xml?(file)
    file.content_type == "text/xml"
  end

  def file_is_pdf?(file)
    file.content_type == "application/pdf"
  end

end
