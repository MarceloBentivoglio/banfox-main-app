require 'test_helper'

class Risk::Decorator::SerasaTest < ActiveSupport::TestCase
  test 'refin' do
    sample_data = {
      refin: {},
      historic: [
        {
          refin: {
            value: 1000
          }
        }
      ]
    }

    decorator = Risk::Decorator::Serasa.new(sample_data)

    assert_equal 0, decorator.refin_value
    assert_equal 1000, decorator.refin_historic_value
  end
end
