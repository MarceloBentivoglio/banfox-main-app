require 'test_helper'

class Risk::Referee::AdminProtestValueDeltaTest < ActiveSupport::TestCase
  test '.call returns a collection of key_indicators' do
    collection_evidence = {
      partner_data: [
        {
          cnpj: '0000000001',
          name: 'John Doe',
          role: 'admin',
          protest: [
            {
              value: 200
            }
          ],
          historic: [
            {
              protest: [
                { 
                  value: 100
                }
              ]
            }
          ]
        },
        {
          cpf: '0000000002',
          name: 'Joane Doe',
          role: 'admin',
          protest: [
            {
              value: 100
            }
          ],
          historic: [
            {
              protest: [
                value: 125
              ]
            }
          ]
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(collection_evidence)
    referee = Risk::Referee::AdminProtestValueDelta.new(decorated_evidence)

    expected = [
      {
        code: 'admin_protest_value_delta_0000000001',
        title: 'Admin Protest Value Delta',
        description: '0000000001',
        params: { green_limit: 0, yellow_limit: 0.5 },
        evidence: {
          historic: 100,
          current: 200,
          document: '0000000001',
          name: 'John Doe' 
        },
        flag: Risk::KeyIndicatorReport::RED_FLAG
      },
      {
        code: 'admin_protest_value_delta_0000000002',
        title: 'Admin Protest Value Delta',
        description: '0000000002',
        params: { green_limit: 0, yellow_limit: 0.5 },
        evidence: {
          historic: 125,
          current: 100,
          document: '0000000002',
          name: 'Joane Doe'
        },
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      },
    ]

    assert_equal expected, referee.call
  end
end