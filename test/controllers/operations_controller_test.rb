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
end
