require 'test_helper'

class OperationsControllerTest < ActionDispatch::IntegrationTest
  test "should get history" do
    get operations_history_url
    assert_response :success
  end

  test "should get new" do
    get operations_new_url
    assert_response :success
  end

  test "should get opened" do
    get operations_opened_url
    assert_response :success
  end

  test "should get show" do
    get operations_show_url
    assert_response :success
  end

  test "should get store" do
    get operations_store_url
    assert_response :success
  end

end
