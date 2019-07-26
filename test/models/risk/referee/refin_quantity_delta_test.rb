require 'test_helper'

class Risk::Referee::RefinQuantityDeltaTest < ActiveSupport::TestCase
  test '.call should create a gray flag if there is only one company_summary' do
    evidences = {
      refin: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create green flag when the historic quantity is 0 and the entity is stable' do
    evidences = {
      refin: [],
      historic: [
        {
          refin: []
        }
      ]
    }

    expected = Risk::KeyIndicatorReport::GREEN_FLAG
    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create yellow flag when the historic quantity is 0 and the entity is growing' do
    evidences = {
      refin: [
        {
          quantity: 1000
        }
      ],
      historic: [
        {
          refin: []
        }
      ]
    }

    expected = Risk::KeyIndicatorReport::YELLOW_FLAG
    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create a green flag' do
    evidences = {
      refin: [
        {
          quantity: 1000
        }
      ],
      historic: [
        {
          refin: [
            {
              quantity: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create a yellow flag' do
    evidences = {
      refin: [
        {
          quantity: 15
        }
      ],
      historic: [
        {
          refin: [
            {
              quantity: 10
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create a red flag' do
    evidences = {
      refin: [
        {
          quantity: 16
        }
      ],
      historic: [
        {
          refin: [
            {
              quantity: 10
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end
end
