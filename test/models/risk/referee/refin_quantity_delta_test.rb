require 'test_helper'

class Risk::Referee::RefinQuantityDeltaTest < ActiveSupport::TestCase
  test '.call should create a gray flag if there is only one company_summary' do
    evidences = {
      refin: {},
      historic: []
    }

    decorated_evidences = Risk::Decorator::Serasa.new(evidences)
    expected = Risk::KeyIndicatorReport::GRAY_FLAG

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create green flag when the historic quantity is 0 and the entity is stable' do
    evidences = {
      refin: {},
      historic: [
        {
          refin: {}
        }
      ]
    }

    expected = Risk::KeyIndicatorReport::GREEN_FLAG
    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create yellow flag when the historic quantity is 0 and the entity is growing' do
     evidences = {
       refin: {
         quantity: 1000
       },
       historic: [
         refin: {}
       ]
     }

    expected = Risk::KeyIndicatorReport::YELLOW_FLAG
    decorated_evidences = Risk::Decorator::Serasa.new(evidences)

    assert_equal expected, Risk::Referee::RefinQuantityDelta.new(decorated_evidences).call
  end

  test '.call should create a green flag' do
    @company_summaries = [
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 10,
          value: 1000,
          last_ocurrence: Date.new(2019, 1, 21)
        }
      ),
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 10,
          value: 1000,
          last_ocurrence: Date.new(2018, 12, 21)
        }
      ),
    ]

    Risk::KeyIndicator.any_instance.expects(:green!)

    Risk::Referee::RefinQuantityDelta.new(@key_indicator_factory, @company_summaries).call
  end

  test '.call should create a yellow flag' do
    @company_summaries = [
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 10,
          value: 1000,
          last_ocurrence: Date.new(2019, 1, 21)
        }
      ),
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 15,
          value: 1000,
          last_ocurrence: Date.new(2018, 12, 21)
        }
      ),
    ]

    Risk::KeyIndicator.any_instance.expects(:yellow!)

    Risk::Referee::RefinQuantityDelta.new(@key_indicator_factory, @company_summaries).call
  end

  test '.call should create a red flag' do
    @company_summaries = [
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 10,
          value: 1000,
          last_ocurrence: Date.new(2019, 1, 21)
        }
      ),
      Risk::Entity::Serasa::CompanySummary.new(
        refin: {
          quantity: 16,
          value: 1000,
          last_ocurrence: Date.new(2018, 12, 21)
        }
      ),
    ]

    Risk::KeyIndicator.any_instance.expects(:red!)

    Risk::Referee::RefinQuantityDelta.new(@key_indicator_factory, @company_summaries).call
  end
end
