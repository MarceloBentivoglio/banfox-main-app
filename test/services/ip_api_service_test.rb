require 'test_helper'

class IpAPIServiceTest < ActiveSupport::TestCase
  test '.call' do
    user = FactoryBot.create(:user, :remote_original_ip)

    data = IpAPIService.new(user).call
  end
end
