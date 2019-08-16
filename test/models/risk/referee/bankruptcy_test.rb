require 'test_helper'

class Risk::Referee::BankruptcyTest < ActiveSupport::TestCase
  test '.call returns red flag if there is any' do
    evidences = {
      bankruptcy: [
        {
          quantity: 1
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'bankruptcy',
      title: 'Bankruptcy',
      description: nil,
      evidence: {
        bankruptcy: true
      },
      params: {
        green: false,
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    assert_equal expected, Risk::Referee::Bankruptcy.new(decorated_evidences).call
  end

  test '.call returns green flag if there is any' do
    evidences = {
      bankruptcy: [
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'bankruptcy',
      title: 'Bankruptcy',
      description: nil,
      evidence: {
        bankruptcy: false
      },
      params: {
        green: false,
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::Bankruptcy.new(decorated_evidences).call
  end

end
