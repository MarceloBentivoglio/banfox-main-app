require 'test_helper'

class RunningRefereesTest < ActiveSupport::TestCase
  setup do
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:call)
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:data)
                         .returns([biort_data])
  end

  test 'run all referees' do
    params = {
      risk_key_indicator_report: {
        input_data: '08588244000149'
      },
      kind: 'recurrent_operation'
    }

    key_indicator_report = Risk::Service::KeyIndicatorReport.new(params, DateTime.current + 1.day).call

    assert_has_expected_key_indicators(key_indicator_report)
  end

  test 'run all referees using an operation' do
    using_shared_operation
    mocked_operation_params = {
      input_data: ['08588244000149'],
      kind: 'recurrent_operation',
      ttl: DateTime.current + 1.day,
      operation_id: @operation.id
    }
    Risk::Service::KeyIndicatorReport.any_instance
                                     .expects(:operation_params)
                                     .returns(mocked_operation_params)

    params = {
      kind: 'recurrent_operation',
      operation_id: @operation.id
    }

    key_indicator_report = Risk::Service::KeyIndicatorReport.new(params, DateTime.current + 1.day).call

    assert_has_expected_key_indicators(key_indicator_report)
  end

  def assert_has_expected_key_indicators(key_indicator_report)
    actual_key_indicators = key_indicator_report.key_indicators["08588244"].map {|k,v| k}

    [
      'refin_value_delta',
      'refin_quantity_delta',
      'lawsuit_quantity_delta',
      'lawsuit_value_delta',
      'pefin_value_delta',
      'pefin_quantity_delta',
      'protest_value_delta',
      'protest_quantity_delta',
      'injuction',
      'partner_entry_date_326273108',
      'founded_in',
      'social_capital',
      'social_capital_realized',
      'company_status',
      'partner_refin_quantity_delta_326273108',
      'partner_refin_value_delta_326273108',
      'partner_lawsuit_quantity_delta_326273108',
      'partner_lawsuit_value_delta_326273108',
      'partner_pefin_quantity_delta_326273108',
      'partner_pefin_value_delta_326273108',
      'partner_protest_quantity_delta_326273108',
      'partner_protest_value_delta_326273108',
    ].each do |expected_key_indicator|
      assert actual_key_indicators.include? expected_key_indicator
    end
  end

  def biort_data
    @biort_data ||= File.new("#{Rails.root}/test/support/files/20190814_BIORT.txt", 'r').read
  end
end
