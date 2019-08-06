require 'test_helper'

class Risk::Referee::LawsuitQuantityDeltaTest < ActiveSupport::TestCase
  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      lawsuit: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic quantity is 0 and the entity is stable' do
    evidences = {
      lawsuit: [],
      historic: [
        {
          lawsuit: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic quantity is 0 and the entity is growing' do
    evidences = {
      lawsuit: [
        {
          quantity: 10
        }
      ],
      historic: [
        lawsuit: [
          {
          }
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      lawsuit: [
        {
          quantity: 10
        }
      ],
      historic: [
        lawsuit: [
          {
            quantity: 10
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
      lawsuit: [
        {
          quantity: 15
        }
      ],
      historic: [
        lawsuit: [
          {
            quantity: 10
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
      lawsuit: [
        {
          quantity: 16
        }
      ],
      historic: [
        lawsuit: [
          {
            quantity: 10
          }
        ]
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::LawsuitQuantityDelta.new(decorated_evidences).assert
  end
end
