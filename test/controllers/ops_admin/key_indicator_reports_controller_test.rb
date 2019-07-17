require 'test_helper'

class OpsAdmin::KeyIndicatorReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, :auth_admin, seller: @seller)

    @input_data = {
      payers: @operation.payers.map {|payer| payer.cnpj},
      seller: @seller.cnpj,
    }
  end
  
  def post_operation
    post ops_admin_key_indicator_reports_path(operation_id: @operation.id, kind: 'recurrent_operation')
  end

  test '.create calls Service::KeyIndicatorReport' do
    key_indicator_report = FactoryBot.create(:key_indicator_report)
    Risk::KeyIndicatorReport.stubs(:create).returns(key_indicator_report)

    Risk::Service::KeyIndicatorReport.any_instance.expects(:call)

    post_operation
  end
end
