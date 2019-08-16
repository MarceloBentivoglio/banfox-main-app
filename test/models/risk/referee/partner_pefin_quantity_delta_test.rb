require 'test_helper'

class Risk::Referee::PartnerPefinQuantityDeltaTest < ActiveSupport::TestCase
  test '.call returns a collection of key_indicators' do
    collection_evidence = {
      partner_data: [
        {
          cpf: '0000000001',
          name: 'John Doe',
          pefin: [
            {
              quantity: 200
            }
          ],
          historic: [
            {
              pefin: [
                { 
                  quantity: 100
                }
              ]
            }
          ]
        },
        {
          cpf: '0000000002',
          name: 'Joane Doe',
          pefin: [
            {
              quantity: 100
            }
          ],
          historic: [
            {
              pefin: [
                quantity: 125
              ]
            }
          ]
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(collection_evidence)
    referee = Risk::Referee::PartnerPefinQuantityDelta.new(decorated_evidence)

    expected = [
      {
        code: 'partner_pefin_quantity_delta_0000000001',
        title: 'Partner Pefin Quantity Delta',
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
        code: 'partner_pefin_quantity_delta_0000000002',
        title: 'Partner Pefin Quantity Delta',
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
