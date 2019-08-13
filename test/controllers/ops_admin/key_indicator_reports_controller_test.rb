require 'test_helper'

class OpsAdmin::KeyIndicatorReportsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, :auth_admin, seller: @seller)

    @query = ["08728220000148", "16532989000114"]

    #Do not allow HTTP calls

    Risk::Fetcher::Serasa.any_instance
      .stubs(:call)

    Risk::Fetcher::Serasa.any_instance
                         .stubs(:data)
                         .returns([serasa_external_data])
  end
  
  def post_with_operation
    post ops_admin_key_indicator_reports_path(operation_id: @operation.id, kind: 'recurrent_operation')
  end

  def post_with_query
    @request = post ops_admin_key_indicator_reports_path(risk_key_indicator_report: { input_data: @query }, kind: 'recurrent_operation')
  end

  def serasa_external_data
    File.open("#{Rails.root}/test/support/files/serasa_example_1.txt").read
  end

  test '.create calls Service::KeyIndicatorReport' do
    mocked_key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    Risk::Service::KeyIndicatorReport.any_instance.expects(:call).returns(mocked_key_indicator_report)

    post_with_operation
  end

  test '.create correctly calls RecurrentOperationStrategy' do
    Risk::Service::RecurrentOperationStrategy.any_instance.expects(:call)

    post_with_operation
  end

  test '.create with query' do
    post_with_query
  end

  test '.create with operation' do
    post_with_operation
  end
end
