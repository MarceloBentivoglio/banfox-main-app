require 'test_helper'

class Risk::Referee::PartnerRefinQuantityDeltaTest < ActiveSupport::TestCase
  test '.call returns a collection of key_indicators' do
    collection_evidence = {
      partner_data: [
        {
          cpf: '0000000001',
          name: 'John Doe',
          refin: [
            {
              quantity: 200
            }
          ],
          historic: [
            {
              refin: [
                { quantity: 100
              }
              ]
            }
          ]
        },
        {
          cpf: '0000000002',
          name: 'Joane Doe',
          refin: [
            {
              quantity: 100
            }
          ],
          historic: [
            {
              refin: [
                quantity: 125
              ]
            }
          ]
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(collection_evidence)
    referee = Risk::Referee::PartnerRefinQuantityDelta.new(decorated_evidence)

    expected = [
      {
        code: 'partner_refin_quantity_delta_0000000001',
        title: 'Partner Refin Quantity Delta',
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
        code: 'partner_refin_quantity_delta_0000000002',
        title: 'Partner Refin Quantity Delta',
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
