require 'test_helper'

class CreateInvoicesFromDocumentsTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
  end

  test "calls ExtractDataFromXml if a file is a xml" do
    xml_stub = fixture_file_upload('files/xml_stub.xml','text/xml')
    mocked_invoice = FactoryBot.create(:invoice)
    mocked_service = mock()
    mocked_service.stubs(:invoice).returns([mocked_invoice])
    ExtractDataFromXml.stubs(:new).with(xml_stub, @seller).returns(mocked_service)
    CreateInvoicesFromDocuments.new([xml_stub], @seller)
  end

  test "calls ExtractDataFromPdf if a file is a pdf" do
    pdf_stub = fixture_file_upload('files/pdf_stub.pdf','application/pdf')
    mocked_invoice = FactoryBot.create(:invoice)
    mocked_service = mock()
    mocked_service.stubs(:invoice).returns([mocked_invoice])
    ExtractDataFromPdf.stubs(:new).with(pdf_stub, @seller).returns(mocked_service)
    CreateInvoicesFromDocuments.new([pdf_stub], @seller)
  end

  test "inform if a file is neither a xml nor a pdf" do
    json_stub = mock()
    json_stub.stubs(:content_type).returns('application/json')
    invoices = CreateInvoicesFromDocuments.new([json_stub], @seller).invoices
    assert_equal invoices.first.message, "File has not a valid type: xml, PDF"
  end
end
