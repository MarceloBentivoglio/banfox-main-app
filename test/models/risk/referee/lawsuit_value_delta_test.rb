require 'test_helper'

class Risk::Referee::LawsuitValueDeltaTest < ActiveSupport::TestCase

  test '.assert should create a gray flag if there is only one company_summary' do
    evidences = {
      lawsuit: [],
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create green flag when the historic value is 0 and the entity is stable' do
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

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create yellow flag when the historic value is 0 and the entity is growing' do
    evidences = {
      lawsuit: [
        {
          value: 1000
        }
      ],
      historic: [
        {
          lawsuit: []
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      lawsuit: [
        {
          value: 1000
        }
      ],
      historic: [
        {
          lawsuit: [
            {
              value: 1100
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a yellow flag' do
   evidences = {
      lawsuit: [
        {
          value: 1500
        }
      ],
      historic: [
        {
          lawsuit: [
            {
              value: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end

  test '.assert should create a red flag' do
    evidences = {
      lawsuit: [
        {
          value: 1600
        }
      ],
      historic: [
        {
          lawsuit: [
            {
              value: 1000
            }
          ]
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::RED_FLAG

    assert_equal expected, Risk::Referee::LawsuitValueDelta.new(decorated_evidences).assert
  end
end
