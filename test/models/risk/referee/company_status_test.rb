require 'test_helper'
class Risk::Referee::CompanyStatusTest < ActiveSupport::TestCase
  test '.call returns a key_indicator with a green_flag' do
    evidences = {
      company_data: {
        company_status: 'ATIVA'
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'company_status',
      title: 'Company Status',
      description: nil,
      evidence: {
        status: 'ATIVA'     
      },
      params: {
        green: 'ATIVA',
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::CompanyStatus.new(decorated_evidence).call

  end

  test '.call returns a key_indicator with a red_flag' do
    evidences = {
      company_data: {
        company_status: 'INATIVA'
      }
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'company_status',
      title: 'Company Status',
      description: nil,
      evidence: {
        status: 'INATIVA'     
      },
      params: {
        green: 'ATIVA',
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    assert_equal expected, Risk::Referee::CompanyStatus.new(decorated_evidence).call

  end


end
