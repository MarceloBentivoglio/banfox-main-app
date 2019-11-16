require 'test_helper'

class Risk::Referee::PartnerLawsuitValueDeltaTest < ActiveSupport::TestCase
  test '.call returns a collection of key_indicators' do
    collection_evidence = {
      partner_data: [
        {
          cnpj: '0000000001',
          name: 'John Doe',
          negative_information: [
            {
              total_value: 200,
              type: 4
            }
          ],
          historic: {
            negative_information: [
              { 
                total_value: 100,
                type: 4
              }
            ]
          }
        },
        {
          cpf: '0000000002',
          name: 'Joane Doe',
          negative_information: [
            {
              total_value: 100,
              type: 4
            }
          ],
          historic: {
            negative_information: [
              total_value: 125,
              type: 4
            ]
          }
        }
      ]
    }

    decorated_evidence = Risk::Decorator::PartnerSerasa.new(collection_evidence)
    referee = Risk::Referee::PartnerLawsuitValueDelta.new(decorated_evidence)

    expected = [
      {
        code: 'partner_lawsuit_value_delta_0000000001',
        title: 'Partner Lawsuit Value Delta',
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
        code: 'partner_lawsuit_value_delta_0000000002',
        title: 'Partner Lawsuit Value Delta',
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
