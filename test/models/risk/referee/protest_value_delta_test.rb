require 'test_helper'

class Risk::Referee::ProtestValueDeltaTest < ActiveSupport::TestCase

  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      protest: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic value is 0 and the entity is stable' do
    evidences = {
      protest: [],
      historic: [
        {
          protest: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic value is 0 and the entity is growing' do
    evidences = {
      protest: [
        {
          value: 1000
        }
      ],
      historic: [
        {
          protest: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert

  end

  test '.assert should create a green flag' do
    evidences = {
      protest: [
        {
          value: 1000
        }
      ],
      historic: [
        {
          protest: [
            {
              value: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a yellow flag' do
    evidences = {
      protest: [
        {
          value: 1500
        }
      ],
      historic: [
        {
          protest: [
            {
              value: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a red flag' do
    evidences = {
      protest: [
        {
          value: 1600
        }
      ],
      historic: [
        {
          protest: [
            {
              value: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end
end
