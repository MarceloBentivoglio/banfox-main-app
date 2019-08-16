require 'test_helper'

class Risk::Referee::AdminLawsuitValueDeltaTest < ActiveSupport::TestCase
  test '.call returns a collection of key_indicators' do
    collection_evidence = {
      partner_data: [
        {
          cpf: '0000000001',
          name: 'John Doe',
          role: 'admin',
          lawsuit: [
            {
              value: 200
            }
          ],
          historic: [
            {
              lawsuit: [
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
          lawsuit: [
            {
              value: 100
            }
          ],
          historic: [
            {
              lawsuit: [
                value: 125
              ]
            }
          ]
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(collection_evidence)
    referee = Risk::Referee::AdminLawsuitValueDelta.new(decorated_evidence)

    expected = [
      {
        code: 'admin_lawsuit_value_delta_0000000001',
        title: 'Admin Lawsuit Value Delta',
        description: '0000000001',
        params: { green_limit: 0, yellow_limit: 0.5 },
        evidence: {
          historic: 100,
          current: 200,
          cpf: '0000000001',
          name: 'John Doe' 
        },
        flag: Risk::KeyIndicatorReport::RED_FLAG
      },
      {
        code: 'admin_lawsuit_value_delta_0000000002',
        title: 'Admin Lawsuit Value Delta',
        description: '0000000002',
        params: { green_limit: 0, yellow_limit: 0.5 },
        evidence: {
          historic: 125,
          current: 100,
          cpf: '0000000002',
          name: 'Joane Doe'
        },
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      },
    ]

    assert_equal expected, referee.call
  end
end
