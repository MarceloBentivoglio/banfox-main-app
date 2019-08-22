require 'test_helper'

class Risk::Referee::RefinLastOccurrenceTest < ActiveSupport::TestCase
  setup do
    Date.stubs(:current).returns(Date.new(2019, 8, 20))
  end

  test '.call creates a red flag' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190816'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'refin_last_occurrence',
      title: 'Refin Last Occurrence',
      description: '',
      evidence: {
        refin: [
          {
            'quantity' => 10,
            'value' => 1000,
            'date' => '20190816'
          }
        ]
      },
      params: {
        green_limit: 30,
        yellow_limit: 5
      },
      flag: Risk::KeyIndicatorReport::RED_FLAG
    }

    assert_equal expected, Risk::Referee::RefinLastOccurrence.new(decorated_evidence).call
  end

  test '.call creates a yellow flag' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190805'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'refin_last_occurrence',
      title: 'Refin Last Occurrence',
      description: '',
      evidence: {
        refin: [
          {
            'quantity' => 10,
            'value' => 1000,
            'date' => '20190805'
          }
        ]
      },
      params: {
        green_limit: 30,
        yellow_limit: 5
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    assert_equal expected, Risk::Referee::RefinLastOccurrence.new(decorated_evidence).call
  end

  test '.call creates a green flag' do
    evidences = {
      refin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190715'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'refin_last_occurrence',
      title: 'Refin Last Occurrence',
      description: '',
      evidence: {
        refin: [
          {
            'quantity' => 10,
            'value' => 1000,
            'date' => '20190715'
          }
        ]
      },
      params: {
        green_limit: 30,
        yellow_limit: 5
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::RefinLastOccurrence.new(decorated_evidence).call
  end
end
