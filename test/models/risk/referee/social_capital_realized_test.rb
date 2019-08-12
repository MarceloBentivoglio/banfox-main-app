require 'test_helper'

class Risk::Referee::SocialCapitalRealizedTest < ActiveSupport::TestCase
  test '.call returns a green flag' do
    evidences = {
      company_data: {
        social_capital_realized: 50_000
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'social_capital_realized',
      title: 'Social Capital Realized',
      description: '',
      evidence: {
        social_capital_realized: 50_000
      },
      params: {
        green_limit: 50_000,
        yellow_limit: 10_000 
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::SocialCapitalRealized.new(decorated_evidences).call
  end

  test '.call returns a yellow flag' do
    evidences = {
      company_data: {
        social_capital_realized: 49_000
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'social_capital_realized',
      title: 'Social Capital Realized',
      description: '',
      evidence: {
        social_capital_realized: 49_000
      },
      params: {
        green_limit: 50_000,
        yellow_limit: 10_000 
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    assert_equal expected, Risk::Referee::SocialCapitalRealized.new(decorated_evidences).call
  end

  test '.call returns a red flag' do
    evidences = {
      company_data: {
        social_capital_realized: 9_000
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'social_capital_realized',
      title: 'Social Capital Realized',
      description: '',
      evidence: {
        social_capital_realized: 9_000
      },
      params: {
        green_limit: 50_000,
        yellow_limit: 10_000 
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    assert_equal expected, Risk::Referee::SocialCapitalRealized.new(decorated_evidences).call
  end

  test '.call returns a gray flag' do
    evidences = {
      company_data: {
        social_capital_realized: nil
      }
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'social_capital_realized',
      title: 'Social Capital Realized',
      description: '',
      evidence: {
        social_capital_realized: nil
      },
      params: {
        green_limit: 50_000,
        yellow_limit: 10_000 
      },
      flag: Risk::KeyIndicatorReport::GRAY_FLAG
    }

    assert_equal expected, Risk::Referee::SocialCapitalRealized.new(decorated_evidences).call
  end
end
