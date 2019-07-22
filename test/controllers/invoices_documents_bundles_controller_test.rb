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

  test '.create only parses the bundle when everything is ok' do
    
  end
end
