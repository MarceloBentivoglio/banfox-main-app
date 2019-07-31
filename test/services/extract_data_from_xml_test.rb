require 'test_helper'

class ExtractDataFromXmlTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
  end

  test 'create an invoice' do
    xml_stub = fixture_file_upload('files/xml_stub.xml','text/xml')
    mocked_document = mock()
    mocked_document.stubs(:attach)
    Invoice.any_instance.stubs(:document).returns(mocked_document)
    assert_difference 'Invoice.count', +1 do
      ExtractDataFromXml.new(xml_stub, @seller)
    end
  end
end
