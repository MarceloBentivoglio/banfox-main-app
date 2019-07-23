require 'test_helper'

class Risk::Fetcher::SerasaTest < ActiveSupport::TestCase
  test '.serasa_request_string' do
    using_shared_operation
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)

    expected = "        IP20NRRFS2        04428103822N            233E 028                                                                                C66M                                                                                                                                                                                                                                                                                                                         S"
    fetcher = Risk::Fetcher::Serasa.new(key_indicator_report)
    assert_equal expected, fetcher.serasa_request_string('44281038')
  end
end
