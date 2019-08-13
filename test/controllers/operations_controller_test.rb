require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, seller: @seller)
  end

  test ".cancel_operation delete the operation and return all the installments to their original situation" do
    ignore_slack_call
    installment_ids = @operation.installments.map { |installment| installment.id }
    assert_difference 'Operation.count', -1 do
      put cancel_operations_path(id: @operation.id)
    end
    
    installment_ids.each do |i|
      installment = Installment.find(i)
      assert_nil installment.operation_id
      assert_nil installment.ordered_at
      assert_equal "available", installment.backoffice_status
    end
  end

  test ".create_document create a document to be signed and redirect to the sign page" do
    checking_account = FactoryBot.create(:checking_account, seller: @seller)
    mocked_doc_info = {"signer_signature_keys"=>
                        []
                      }
    mocked_doc_key = "123"
    mocked_document = mock()
    mocked_document.expects(:sign_document_info).returns(mocked_doc_info)
    mocked_document.expects(:sign_document_key).returns(mocked_doc_key)
    SignDocuments.stubs(:new).returns(mocked_document)
    post create_document_operations_path(operation: {checking_account_id: checking_account.id})
    assert_redirected_to sign_document_operations_path
  end
end
