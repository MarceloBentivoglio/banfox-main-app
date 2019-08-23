require 'test_helper'

class Risk::Decorator::SerasaTest < ActiveSupport::TestCase
  test 'refin' do
    sample_data = {
      refin: [],
      historic: [
        {
          refin: [
            {
              total_value: 1000
            }
          ]
        }
      ]
    }

    decorator = Risk::Decorator::Serasa.new(sample_data)

    assert_equal 0, decorator.refin_value
    assert_equal 1000, decorator.refin_historic_value
  end

  test '.partner_document' do
    sample_data = [
      {
        cpf: '11111111111'
      },
      {
        cnpj: '22222222'
      }
    ]

    expected_document = '11111111111'
    decorator = Risk::Decorator::Serasa.new(sample_data.first)
    assert_equal expected_document, decorator.partner_document

    expected_document = '22222222'
    decorator = Risk::Decorator::Serasa.new(sample_data.last)
    assert_equal expected_document, decorator.partner_document
  end
end
