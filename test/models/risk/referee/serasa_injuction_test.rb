require 'test_helper'

class Risk::Referee::SerasaInjuctionTest < ActiveSupport::TestCase
  test '.call creates a yellow flag' do
    evidences = {
      company_data: {
        injuction: true
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::SerasaInjuction.new(decorated_evidences).call
  end

  test '.call creates a green flag' do
    evidences = {
      company_data: {
        injuction: false
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::SerasaInjuction.new(decorated_evidences).call
  end
end
