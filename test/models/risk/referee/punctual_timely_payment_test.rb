require 'test_helper'

class Risk::Referee::PunctualTimelyPaymentTest < ActiveSupport::TestCase
  test '.call returns with a green flag' do
    data = {
      timely_payment: [
        {
          :description=>"PONTUAL      ",
          :code=>" B6",
          :code_description=>" 2 MIL A 2,5 MIL     ",
          :period_quantity_start=>"000000000002000",
          :period_quantity_end=>"000000000002500",
          :percentage_start=>"08900",
          :percentage_end=>"09100"
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(data)
    
    expected = {
      code: 'punctual_timely_payment',
      title: 'Punctual Timely Payment',
      description: '',
      params: {
        green_limit: 80.0,
      },

      evidence: {
        "description"=>"PONTUAL      ",
        "code"=>" B6",
        "code_description"=>" 2 MIL A 2,5 MIL     ",
        "period_quantity_start"=>"000000000002000",
        "period_quantity_end"=>"000000000002500",
        "percentage_start"=>"08900",
        "percentage_end"=>"09100"
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::PunctualTimelyPayment.new(decorated_evidence).call
  end

  test '.call returns with a yellow flag' do
    data = {
      timely_payment: [
        {
          :description=>"PONTUAL      ",
          :code=>" B6",
          :code_description=>" 2 MIL A 2,5 MIL     ",
          :period_quantity_start=>"000000000002000",
          :period_quantity_end=>"000000000002500",
          :percentage_start=>"07700",
          :percentage_end=>"07900"
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(data)
    
    expected = {
      code: 'punctual_timely_payment',
      title: 'Punctual Timely Payment',
      description: '',
      params: {
        green_limit: 80.0,
      },

      evidence: {
        "description"=>"PONTUAL      ",
        "code"=>" B6",
        "code_description"=>" 2 MIL A 2,5 MIL     ",
        "period_quantity_start"=>"000000000002000",
        "period_quantity_end"=>"000000000002500",
        "percentage_start"=>"07700",
        "percentage_end"=>"07900"
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    assert_equal expected, Risk::Referee::PunctualTimelyPayment.new(decorated_evidence).call
  end
end
