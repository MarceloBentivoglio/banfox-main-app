require 'test_helper'

class InvoicesDocumentsBundlesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, seller: @seller)

    @input_data = {
      seller: @seller.cnpj,
    }

  end
  
  test '.create inform that at least one NF is needed' do
    post invoices_documents_bundles_path

    assert_equal "É necessário ao menos subir uma nota fiscal", flash[:alert]
  end

  test '.create informs if the bundle has a NF with an unmatch CNPJ with the seller' do
    document_mock = mock()
    document_mock.stubs(:content_type).returns('application/XML')

    mocked_params = {
      invoices_documents_bundle: { documents: [document_mock] }
    }

    InvoicesDocumentsBundlesController.any_instance.stubs(:params).returns(mocked_params)

    stub_error = [RuntimeError.new("Invoice do not belongs to seller")]

    CreateInvoicesFromDocuments.any_instance.stubs(:invoices).returns(stub_error)

    post invoices_documents_bundles_path

    assert_equal ["Uma das notas que você subiu contem um CNPJ que não confere com o seu"], flash[:alert]
  end

  test '.create informs if the bundle has a file of an unsupported type' do
    document_mock = mock()
    document_mock.stubs(:content_type).returns('application/json')

    mocked_params = {
      invoices_documents_bundle: { documents: [document_mock] }
    }

    InvoicesDocumentsBundlesController.any_instance.stubs(:params).returns(mocked_params)

    stub_error = [RuntimeError.new("File has not a valid type: xml, PDF")]

    CreateInvoicesFromDocuments.any_instance.stubs(:invoices).returns(stub_error)

    post invoices_documents_bundles_path

    assert_equal ["Um dos arquivos que você subiu não é xml nem PDF"], flash[:alert]
  end

  test '.create redirect to analysis when everything is ok' do
    document_mock = mock()
    document_mock.stubs(:content_type).returns('application/pdf')

    mocked_params = {
      invoices_documents_bundle: { documents: [document_mock] }
    }

    InvoicesDocumentsBundlesController.any_instance.stubs(:params).returns(mocked_params)

    invoice_mock = mock()
    invoice_mock.expects(:doc_parser_data?).returns(false)
    invoice_mock.expects(:document).returns(document_mock)

    CreateInvoicesFromDocuments.any_instance.expects(:invoices).returns([invoice_mock])

    post invoices_documents_bundles_path

    assert_redirected_to analysis_invoices_documents_bundles_path
  end

  test '.create informs that the xml is duplicated' do
    xml_stub = fixture_file_upload('files/xml_stub.xml','text/xml')

    stub_error = [RuntimeError.new("Duplicated xml")]
    mocked_return = mock()
    mocked_return.stubs(:invoices).returns(stub_error)

    mocked_params = {
      invoices_documents_bundle: { documents: [xml_stub] }
    }

    InvoicesDocumentsBundlesController.any_instance.stubs(:params).returns(mocked_params)

    CreateInvoicesFromDocuments.stubs(:new).with([xml_stub], @seller).returns(mocked_return)

    post invoices_documents_bundles_path

    assert_equal ["O xml enviado é duplicado"], flash[:alert]
  end
end
