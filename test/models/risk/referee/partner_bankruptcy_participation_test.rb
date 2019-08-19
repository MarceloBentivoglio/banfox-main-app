require 'test_helper'

class Risk::Referee::PartnerBankruptyParticipationTest < ActiveSupport::TestCase
  test '.call returns a key indicator with the correct flag' do
    evidences = {
      partner_data: [
        {
          cnpj: '000001',
          name: 'John Doe',
          bankruptcy_participation: [
            {
              quantity: 1
            }
          ]
        },
        {
          cnpj: '000002',
          name: 'John DoeX',
          bankruptcy_participation: []
        },
      ]
    }

    decorated_evidences = Risk::Decorator::PartnerSerasa.new(evidences)

    expected = [
      {
        code: 'partner_bankruptcy_participation_000001',
        title: 'Partner Bankruptcy Participation',
        description: '000001',
        params: {
          green: false
        },
        evidence: {
          document: '000001',
          name: 'John Doe',
          bankruptcy_participation: true
        },
        flag: Risk::KeyIndicatorReport::RED_FLAG
      },
      {
        code: 'partner_bankruptcy_participation_000002',
        title: 'Partner Bankruptcy Participation',
        description: '000002',
        params: {
          green: false
        },
        evidence: {
          document: '000002',
          name: 'John DoeX',
          bankruptcy_participation: false
        },
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      }
    ]

    assert_equal expected, Risk::Referee::PartnerBankruptcyParticipation.new(decorated_evidences).call
  end
end
