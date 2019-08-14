require 'test_helper'

class Risk::Referee::NonProfitTest < ActiveSupport::TestCase
  test '.call returns a green flag if non-profit is false' do
    evidences = {
      company_data: {
        non_profit: false
      }
    }

    expected = {
      code: 'non_profit_organization',
      title: 'Non Profit Organization',
      description: '',
      evidence: {
        non_profit: false
      },
      params: {
        green: false
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    assert_equal expected, Risk::Referee::NonProfit.new(decorated_evidences).call
  end

  test '.call returns a red flag if non-profit is true' do
    evidences = {
      company_data: {
        non_profit: true
      }
    }

    expected = {
      code: 'non_profit_organization',
      title: 'Non Profit Organization',
      description: '',
      evidence: {
        non_profit: true
      },
      params: {
        green: false
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    assert_equal expected, Risk::Referee::NonProfit.new(decorated_evidences).call
  end

end
