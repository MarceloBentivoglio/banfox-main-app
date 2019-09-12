require 'test_helper'

class SignupServiceTest < ActiveSupport::TestCase

  test ".call returns a user with a seller" do
    mock_params = {"email"=>"test@corp.com", 
                   "password"=>"123123", 
                   "full_name"=>"Teste Virgula", 
                   "mobile"=>"(11) 9 9889-9889", 
                   "cnpj"=>"13.213.213/2131-23"}

    assert_difference 'User.count', +1 do
      user = SignupService.call(mock_params)
      assert_equal Seller.last.id, user.seller_id
    end
  end

end
