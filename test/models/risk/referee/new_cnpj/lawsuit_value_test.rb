require 'test_helper'

class Risk::Referee::NewCNPJ::LawsuitValueTest < ActiveSupport::TestCase
  test '.assert should create yellow flag' do
    evidences = {
      negative_information: [
        {
          type: "4",
          total_value: "1"
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::YELLOW_FLAG

    assert_equal expected, Risk::Referee::NewCNPJ::LawsuitValue.new(decorated_evidences).assert
  end

  test '.assert should create a green flag' do
    evidences = {
      negative_information: [
        {
          type: "4",
          total_value: "0"
        }
      ]
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GREEN_FLAG

    assert_equal expected, Risk::Referee::NewCNPJ::LawsuitValue.new(decorated_evidences).assert
  end
end
