require 'test_helper'

class Risk::Referee::PartnerBankruptyParticipationTest < ActiveSupport::TestCase
  test '.call returns a key indicator with the correct flag' do
    evidences = {
      partner_data: [
        {
          cnpj: '000001',
          bankruptcy_participation: [
            {
              quantity: 1
            }
          ]
        },
        {
          cnpj: '000002',
          bankruptcy_participation: []
        },
      ]
    }

    decorated_evidences = Risk::Decorator::PartnerSerasa.new(evidences)

    expected = [
    
    ]
  end
end
