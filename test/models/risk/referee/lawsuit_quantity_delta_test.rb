require 'test_helper'

class Risk::Referee::LawsuitQuantityDeltaTest < ActiveSupport::TestCase
  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      negative_information: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic quantity is 0 and the entity is stable' do
    evidences = {
      negative_information: [],
      historic: [
        {
          negative_information: [],
          type: 4
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic quantity is 0 and the entity is growing' do
    evidences = {
      negative_information: [
        {
          quantity: 10,
          type: 4
        }
      ],
      historic: [
        negative_information: [
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      negative_information: [
        {
          quantity: 10,
          type: 4
        }
      ],
      historic: [
        negative_information: [
          {
            quantity: 10,
            type: 4
          }
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a yellow flag' do
    evidences = {
      negative_information: [
        {
          quantity: 15,
          type: 4
        }
      ],
      historic: [
        negative_information: [
          {
            quantity: 10,
            type: 4
          }
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a red flag' do
    evidences = {
      negative_information: [
        {
          quantity: 16,
          type: 4
        }
      ],
      historic: [
        negative_information: [
          {
            quantity: 10,
            type: 4
          }
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end
end
