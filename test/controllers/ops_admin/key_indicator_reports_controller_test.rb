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

    #Do not allow HTTP calls
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:call)
                         .returns(serasa_external_data)
  end
  
  def post_operation
    post ops_admin_key_indicator_reports_path(operation_id: @operation.id, kind: 'recurrent_operation')
  end

  def serasa_external_data
    File.open("#{Rails.root}/test/support/files/serasa_example_1.txt").read
  end

  test '.create calls Service::KeyIndicatorReport' do
    Risk::Service::KeyIndicatorReport.any_instance.expects(:call)

    post_operation
  end

  test '.create correctly calls RecurrentOperationStrategy' do
    Risk::Service::RecurrentOperationStrategy.any_instance.expects(:call)

    post_operation
  end

  test '.create' do
    post_operation
  end
end
