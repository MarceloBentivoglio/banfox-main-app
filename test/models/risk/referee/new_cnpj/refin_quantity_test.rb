require 'test_helper'

class Risk::Referee::NewCNPJ::RefinQuantityTest < ActiveSupport::TestCase
  test '.assert should create yellow flag' do
    evidences = {
      refin: [
        {
          quantity: 1
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::NewCNPJ::RefinQuantity.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      refin: [
        {
          quantity: 0
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::NewCNPJ::RefinQuantity.new(decorated_evidences).assert
  end
end
