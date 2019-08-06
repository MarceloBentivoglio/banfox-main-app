require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, seller: @seller)
  end

  test ".cancel_operation delete the operation and return all the installments to their previous situation" do
    installment_id = @operation.installments.first.id
    assert_difference 'Operation.count', -1 do
      put cancel_operation_operations_path(id: @operation.id)
    end
    new_installment = Installment.find(installment_id)
    assert_nil new_installment.operation_id
    assert_nil new_installment.ordered_at
    assert_equal "available", new_installment.backoffice_status
  end
end
