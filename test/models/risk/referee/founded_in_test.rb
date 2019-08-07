require 'test_helper'

class Risk::Referee::FoundedInTest < ActiveSupport::TestCase
  setup do
    Date.stubs(:today).returns(Date.new(2019,8,7))
  end

  test '.assert returns a key_indicator with a red flag' do
    evidences = {
      company_data: {
        founded_in: '20190101'
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'founded_in',
      title: 'Founded In',
      description: '01/01/2019',
      evidence: {
        founded_in: Date.new(2019,1,1)
      },
      params: {
        yellow_limit: 3,
        red_limit: 2
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    assert_equal expected, Risk::Referee::FoundedIn.new(decorated_evidence).call
  end

  test '.assert returns a key_indicator with a yellow flag' do
    evidences = {
      company_data: {
        founded_in: '20170101'
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'founded_in',
      title: 'Founded In',
      description: '01/01/2017',
      evidence: {
        founded_in: Date.new(2017,1,1)
      },
      params: {
        yellow_limit: 3,
        red_limit: 2
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    actual = Risk::Referee::FoundedIn.new(decorated_evidence).call
    
    assert_equal expected, Risk::Referee::FoundedIn.new(decorated_evidence).call
  end

  test '.assert returns a key_indicator with a green flag' do
    evidences = {
      company_data: {
        founded_in: '20140101'
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'founded_in',
      title: 'Founded In',
      description: '01/01/2014',
      evidence: {
        founded_in: Date.new(2014,1,1)
      },
      params: {
        yellow_limit: 3,
        red_limit: 2
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    actual = Risk::Referee::FoundedIn.new(decorated_evidence).call
    
    assert_equal expected, Risk::Referee::FoundedIn.new(decorated_evidence).call
  end

  test '.assert returns a key_indicator with a gray flag' do
    evidences = {
      company_data: {
        founded_in: ''
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'founded_in',
      title: 'Founded In',
      description: '//',
      evidence: {
        founded_in: nil
      },
      params: {
        yellow_limit: 3,
        red_limit: 2
      },
      flag: Risk::KeyIndicatorReport::GRAY_FLAG
    }

    actual = Risk::Referee::FoundedIn.new(decorated_evidence).call
    
    assert_equal expected, Risk::Referee::FoundedIn.new(decorated_evidence).call
  end
end
