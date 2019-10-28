require 'test_helper'

class RunningRefereesTest < ActiveSupport::TestCase
  setup do
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:call)
    Risk::Fetcher::Serasa.any_instance
                         .stubs(:data)
                         .returns([biort_data])
  end


  test 'run all referees with new_cnpj' do
    params = {
      risk_key_indicator_report: {
        input_data: '08588244000149'
      },
      kind: 'new_cnpj'
    }
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
      'serasa_queries',
      'bankruptcy',
      'partner_refin_quantity_delta_326273108',
      'partner_refin_value_delta_326273108',
      'partner_lawsuit_quantity_delta_326273108',
      'partner_lawsuit_value_delta_326273108',
      'partner_pefin_quantity_delta_326273108',
      'partner_pefin_value_delta_326273108',
      'partner_protest_quantity_delta_326273108',
      'partner_protest_value_delta_326273108',
      'partner_bankruptcy_participation_326273108'
    ].each do |expected_key_indicator|
      assert actual_key_indicators.include? expected_key_indicator
    end
  end

  def biort_data
    @biort_data ||= File.new("#{Rails.root}/test/support/files/20190814_BIORT.txt", 'r').read
  end
end
