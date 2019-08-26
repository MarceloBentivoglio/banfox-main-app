require 'test_helper'

class Risk::Referee::ProtestValueDeltaTest < ActiveSupport::TestCase

  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      negative_information: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic value is 0 and the entity is stable' do
    evidences = {
      negative_information: [],
      historic: [
        {
          negative_information: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic value is 0 and the entity is growing' do
    evidences = {
      negative_information: [
        {
          value: 1000
        }
      ],
      historic: [
        {
          negative_information: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::ProtestValueDelta.new(decorated_evidences).assert

  end

  test '.assert should create a green flag' do
    evidences = {
      negative_information: [
        {
          :currency=>"R$ ",
          :value=>"0000000001000",
        }
      ],
      historic: [
        {
          negative_information: [
            {
                :currency=>"R$ ",
                :value=>"0000000001000",
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
      negative_information: [
        {
          value: 1500
        }
      ],
      historic: [
        {
          negative_information: [
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
      negative_information: [
        {
          value: 1600
        }
      ],
      historic: [
        {
          negative_information: [
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
