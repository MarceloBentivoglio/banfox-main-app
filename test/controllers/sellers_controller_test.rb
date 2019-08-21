require 'test_helper'

class SellersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    using_shared_operation
    sign_in FactoryBot.create(:user, seller: @seller)
  end

  test ".analysis informs seller revenue and contact info when rejected by insuficient_revenue" do
    #TODO
    #Need to find a way to check SlackMessage @content to assert
    #ignore_slack_call
    #@seller.insuficient_revenue!
    #mocked_cpf_check = mock()
    #mocked_cpf_check.stubs(:analyze).returns(false)
    #mocked_slack = mock()
    #mocked_slack.stubs(:send_now).returns(true)
    #CpfCheckRF.stubs(:new).with(@seller).returns(mocked_cpf_check)
    #get sellers_analysis_path
  end
end
