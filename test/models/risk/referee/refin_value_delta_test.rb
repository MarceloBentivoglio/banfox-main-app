require 'test_helper'

class Risk::Referee::RefinValueDeltaTest < ActiveSupport::TestCase

  test '.assert should create a gray flag if there is no historic' do
    evidences = {
      refin: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic value is 0 and the entity is stable' do
    evidences = {
      refin: [],
      historic: [
        {
          refin: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG
    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic value is 0 and the entity is growing' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1000,
          date: Date.new(2019,1,21)
        }
      ],
      historic: [
        {
          refin: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG
    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1000,
          date: Date.new(2019,1,21)
        }
      ],
      historic: [
        {
          refin: [
            {
              quantity: 10,
              value: 1000,
              date: Date.new(2018,12,21)
            }

          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a yellow flag' do
    evidences = {
      refin: [
        {
          quantity: 9,
          value: 1500,
          date: Date.new(2019,1,21)
        }
      ],
      historic: [
        refin: [
          {
            quantity: 10,
            value: 1000,
            date: Date.new(2018,12,21)
          }
        ],
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a red flag' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1600,
          date: Date.new(2019,1,21)
        }
      ],
      historic: [
        {
          refin: [
            {
              quantity: 9,
              value: 1000,
              date: Date.new(2018,12,21)
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::RefinValueDelta.new(decorated_evidences).assert
  end
end
