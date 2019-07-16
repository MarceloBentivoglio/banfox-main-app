require 'test_helper'

class Risk::Pipeline::BaseTest < ActiveSupport::TestCase
  class SpecificPipeline < Risk::Pipeline::Base
    required_params :cnpj
    fetch_from :serasa
  end

  setup do
    key_indicator_report = FactoryBot.create(:key_indicator_report)
    @pipeline = SpecificPipeline.new(key_indicator_report)
  end

  test '.valid_input_data? returns true if requirements are satisfied' do
    assert_equal true, @pipeline.valid_input_data?
  end

  test '.require_fetcher? returns true if external data access is necessary' do
    assert_equal true, @pipeline.require_fetcher?
  end
end
