require 'test_helper'

class Risk::Referee::ShareCapitalTest < ActiveSupport::TestCase
  test '.assert generates a red flag' do
    evidences = mock
    evidences.expects(:share_capital).returns(6_000)

    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::ShareCapital.new(evidences).assert
  end

  test '.assert generates a yellow flag' do
    evidences = mock
    evidences.expects(:share_capital).returns(15_000)

    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::ShareCapital.new(evidences).assert
  end

  test '.assert generates a green flag' do
    evidences = mock
    evidences.expects(:share_capital).returns(50_000)

    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::ShareCapital.new(evidences).assert
  end
end
