require 'test_helper'

class Risk::Referee::PefinQuantityDeltaTest < ActiveSupport::TestCase

  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      pefin: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic quantity is 0 and the entity is stable' do
    evidences = {
      pefin: [],
      historic: {
        pefin: []
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic quantity is 0 and the entity is growing' do
    evidences = {
      pefin: [
        {
          quantity: 1000
        }
      ],
      historic: {
        pefin: []
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      pefin: [
        {
          quantity: 1000
        }
      ],
      historic: {
        pefin: [
          {
            quantity: 1000
          }
        ]
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a yellow flag' do
    evidences = {
      pefin: [
        {
          quantity: 1500
        }
      ],
      historic: {
        pefin: [
          {
            quantity: 1000
          }
        ]
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a red flag' do
    evidences = {
      pefin: [
        {
          quantity: 1600
        }
      ],
      historic: {
        pefin: [
          {
            quantity: 1000
          }
        ]
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::PefinQuantityDelta.new(decorated_evidences).assert
  end
end
