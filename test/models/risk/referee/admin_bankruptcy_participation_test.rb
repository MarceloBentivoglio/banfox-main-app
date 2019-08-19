require 'test_helper'

class Risk::Referee::AdminBankruptyParticipationTest < ActiveSupport::TestCase
  test '.call returns a key indicator with the correct flag' do
    evidences = {
      partner_data: [
        {
          cnpj: '000001',
          role: 'admin',
          name: 'John Doe',
          bankruptcy_participation: [
            {
              quantity: 1
            }
          ]
        },
        {
          cnpj: '000002',
          role: 'admin',
          name: 'John DoeX',
          bankruptcy_participation: []
        },
      ]
    }

    decorated_evidences = Risk::Decorator::PartnerSerasa.new(evidences)

    expected = [
      {
        code: 'admin_bankruptcy_participation_000001',
        title: 'Admin Bankruptcy Participation',
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
        code: 'admin_bankruptcy_participation_000002',
        title: 'Admin Bankruptcy Participation',
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

    assert_equal expected, Risk::Referee::AdminBankruptcyParticipation.new(decorated_evidences).call
  end
end
