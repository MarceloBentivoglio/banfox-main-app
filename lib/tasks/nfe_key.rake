namespace :nfe_key do
  desc "Give invoices their NFe key"
  task add_nfe_key_to_invoices: :environment do
    Invoice.all.each do |invoice|
      unless invoice.document.attachment.nil?
        if invoice.document.content_type == "application/xml"
          xml = Nokogiri::XML(invoice.document.download)
          unless xml.search("chNFe").text.blank?
            nfe_key = xml.search("chNFe").text.strip
            invoice.nfe_key = nfe_key
            invoice.save
          end
        end
      end
    end
  end

end
