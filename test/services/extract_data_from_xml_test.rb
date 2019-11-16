require 'test_helper'

class ExtractDataFromXmlTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
  end

  test 'create an invoice' do
    xml_stub = fixture_file_upload('files/notaDeTeste.xml','text/xml')
    assert_difference 'Invoice.count', +1 do
      DataParsing::ExtractDataFromXml.new(xml_stub, @seller)
    end
  end

  test '.check_if_duplicated_chNFe informs if the xml is duplicated' do
    xml_stub = fixture_file_upload('files/notaDeTeste2.xml', 'text/xml')
    mocked_invoice = FactoryBot.create(:invoice)
    Invoice.any_instance.stubs(:find_by_nfe_key).returns(mocked_invoice)
    response = DataParsing::ExtractDataFromXml.new(xml_stub, @seller)
    assert_equal "Duplicated xml", response.invoice.message
  end
  
  test '.check_if_duplicated_chNFe informs if the xml has no nfe_key' do
    xml_stub = fixture_file_upload('files/xml_stub.xml', 'text/xml')
    response = DataParsing::ExtractDataFromXml.new(xml_stub, @seller)
    assert_equal "Nf key not found", response.invoice.message
  end

end
