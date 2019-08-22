require 'test_helper'

class Risk::Referee::PefinLastOccurrenceTest < ActiveSupport::TestCase
  setup do
    Date.stubs(:current).returns(Date.new(2019, 8, 20))
  end

  test '.call creates a red flag' do
    evidences = {
      pefin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190816'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'pefin_last_occurrence',
      title: 'Pefin Last Occurrence',
      description: '',
      evidence: {
        pefin: [
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

    assert_equal expected, Risk::Referee::PefinLastOccurrence.new(decorated_evidence).call
  end

  test '.call creates a yellow flag' do
    evidences = {
      pefin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190815'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'pefin_last_occurrence',
      title: 'Pefin Last Occurrence',
      description: '',
      evidence: {
        pefin: [
          {
            'quantity' => 10,
            'value' => 1000,
            'date' => '20190815'
          }
        ]
      },
      params: {
        green_limit: 30,
        yellow_limit: 5,
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    assert_equal expected, Risk::Referee::PefinLastOccurrence.new(decorated_evidence).call
  end

  test '.call creates a green flag' do
    evidences = {
      pefin: [
        {
          quantity: 10,
          value: 1000,
          date: '20190720'
        }
      ]
    }

    decorated_evidence = Risk::Decorator::Serasa.new(evidences)

    expected = {
      code: 'pefin_last_occurrence',
      title: 'Pefin Last Occurrence',
      description: '',
      evidence: {
        pefin: [
          {
            'quantity' => 10,
            'value' => 1000,
            'date' => '20190720'
          }
        ]
      },
      params: {
        green_limit: 30,
        yellow_limit: 5,
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::PefinLastOccurrence.new(decorated_evidence).call
  end
end
