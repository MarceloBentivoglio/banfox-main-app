require 'test_helper'

class InstallmentsControllerTest < ActionDispatch::IntegrationTest
  test "should get destroy" do
    get installments_destroy_url
    assert_response :success
  end

end
