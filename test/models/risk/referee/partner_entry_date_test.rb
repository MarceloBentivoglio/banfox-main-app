require 'test_helper'

class Risk::Referee::PartnerEntryDateTest < ActiveSupport::TestCase
  setup do
    Date.stubs(:today).returns(Date.new(2019, 7, 8))
  end

  test '.assert returns a key_indicator with a yellow flag' do
    evidences = {
      partner_documents: [
        {
          name: 'Nome 1',
          pf_or_pj: 'J',
          cpf_or_cnpj: '111111111', 
          entry_date: '20190101'
        },
        {
          name: 'Nome 2',
          pf_or_pj: 'F',
          cpf_or_cnpj: '222222222',
          entry_date: '20160101'
        },
        {
          name: 'Nome 3',
          pf_or_pj: 'F',
          cpf_or_cnpj: '33333333',
          entry_date: 'xxxx'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = [
      {
        code: 'partner_entry_date_111111111',
        title: 'Partner Entry Date',
        description: '2019-01-01',
        evidence: {
          name: 'Nome 1',
          pf_or_pj: 'J',
          cpf_or_cnpj: '111111111',
          entry_date: Date.new(2019,1,1)
        },
        params: {
          green_limit: 2
        },
        flag: Risk::KeyIndicatorReport::YELLOW_FLAG
      },
      {
        code: 'partner_entry_date_222222222',
        title: 'Partner Entry Date',
        description: '2016-01-01',
        evidence: {
          name: 'Nome 2',
          pf_or_pj: 'F',
          cpf_or_cnpj: '222222222',
          entry_date: Date.new(2016,1,1)
        },
        params: {
          green_limit: 2
        },
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      },
      {
        code: 'partner_entry_date_33333333',
        title: 'Partner Entry Date',
        description: nil,
        evidence: {
          name: 'Nome 3',
          pf_or_pj: 'F',
          cpf_or_cnpj: '33333333',
          entry_date: nil
        },
        params: {
          green_limit: 2
        },
        flag: Risk::KeyIndicatorReport::GRAY_FLAG
      }
    ]

    assert_equal expected, Risk::Referee::PartnerEntryDate.new(decorated_evidence).call
  end
end
