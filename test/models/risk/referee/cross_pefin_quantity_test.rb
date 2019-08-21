require 'test_helper'

class Risk::Referee::CrossPefinQuantityTest < ActiveSupport::TestCase
  test '.call returns a green flag and ignores pefin_quantity_delta' do
    key_indicators = {
      '00000' => {
        'pefin_value_delta' => {
          'evidence' => {
            'historic_value' => 50,
            'current_value' => 110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        },
        'pefin_quantity_delta' => {
          'evidence' => {
            'historic_quantity' => 100,
            'current_quantity' => 101
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        }
      }
    }.with_indifferent_access

    key_indicator_report = FactoryBot.create(:key_indicator_report)
    key_indicator_report.stubs(:key_indicators).returns(key_indicators)

    decorated_evidences = Risk::Decorator::KeyIndicatorReport.new(key_indicator_report)

    expected = {
      'code': 'cross_pefin_quantity',
      'title': 'Cross Pefin Quantity',
      'description': '',
      'evidence': {
        'pefin_value_delta' => {
          'evidence' =>  {
            'historic_value' =>  50,
            'current_value' =>  110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG,
        },
        'pefin_quantity_delta' => {
          'evidence' =>  {
            'historic_quantity' =>  100,
            'current_quantity' =>  101
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG,
          'ignored' => true
        }
      },
      'params': {
        'green_limit': 0.1
      },
      'flag': Risk::KeyIndicatorReport::GREEN_FLAG
    }

    decorated_evidences.each_cnpj do |cnpj, evidence|
      assert_equal expected, Risk::Referee::CrossPefinQuantity.new(evidence).call
    end
  end

  test '.call returns a yellow flag and do not ignore pefin_quantity_delta because it has a red_flag' do
    key_indicators = {
      '00000' => {
        'pefin_value_delta' => {
          'evidence' => {
            'historic_value' => 50,
            'current_value' => 110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        },
        'pefin_quantity_delta' => {
          'evidence' => {
            'historic_quantity' => 100,
            'current_quantity' => 101
          },
          'flag' => Risk::KeyIndicatorReport::RED_FLAG
        }
      }
    }.with_indifferent_access

    key_indicator_report = FactoryBot.create(:key_indicator_report)
    key_indicator_report.stubs(:key_indicators).returns(key_indicators)

    decorated_evidences = Risk::Decorator::KeyIndicatorReport.new(key_indicator_report)

    expected = {
      'code': 'cross_pefin_quantity',
      'title': 'Cross Pefin Quantity',
      'description': '',
      'evidence': {
        'pefin_value_delta' => {
          'evidence' =>  {
            'historic_value' =>  50,
            'current_value' =>  110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        },
        'pefin_quantity_delta' => {
          'evidence' =>  {
            'historic_quantity' =>  100,
            'current_quantity' =>  101
          },
          'flag' => Risk::KeyIndicatorReport::RED_FLAG
        }
      },
      'params': {
        'green_limit': 0.1
      },
      'flag': Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    decorated_evidences.each_cnpj do |cnpj, evidence|
      assert_equal expected, Risk::Referee::CrossPefinQuantity.new(evidence).call
    end
  end

  test '.call returns a green flag and do not ignore pefin_quantity_delta because it has a green_flag' do
    key_indicators = {
      '00000' => {
        'pefin_value_delta' => {
          'evidence' => {
            'historic_value' => 110,
            'current_value' => 110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        },
        'pefin_quantity_delta' => {
          'evidence' => {
            'historic_quantity' => 100,
            'current_quantity' => 101
          },
          'flag' => Risk::KeyIndicatorReport::GREEN_FLAG
        }
      }
    }.with_indifferent_access

    key_indicator_report = FactoryBot.create(:key_indicator_report)
    key_indicator_report.stubs(:key_indicators).returns(key_indicators)

    decorated_evidences = Risk::Decorator::KeyIndicatorReport.new(key_indicator_report)

    expected = {
      'code': 'cross_pefin_quantity',
      'title': 'Cross Pefin Quantity',
      'description': '',
      'evidence': {
        'pefin_value_delta' => {
          'evidence' =>  {
            'historic_value' =>  110,
            'current_value' =>  110
          },
          'flag' => Risk::KeyIndicatorReport::YELLOW_FLAG
        },
        'pefin_quantity_delta' => {
          'evidence' =>  {
            'historic_quantity' =>  100,
            'current_quantity' =>  101
          },
          'flag' => Risk::KeyIndicatorReport::GREEN_FLAG
        }
      },
      'params': {
        'green_limit': 0.1
      },
      'flag': Risk::KeyIndicatorReport::GREEN_FLAG
    }

    decorated_evidences.each_cnpj do |cnpj, evidence|
      assert_equal expected, Risk::Referee::CrossPefinQuantity.new(evidence).call
    end
  end
end
