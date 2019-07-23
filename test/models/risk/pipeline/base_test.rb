require 'test_helper'

class Risk::Pipeline::BaseTest < ActiveSupport::TestCase
  class SpecificReferee
    attr_accessor :title, :description, :code
    def initialize(data)
      @title = 'Very Specific Referee'
      @code = 'referee_specific'
      @description = 'It judges things'
    end

    def call
    end
  end

  class SpecificPipeline < Risk::Pipeline::Base
    required_params :cnpj
    fetch_from :serasa
    run_referees SpecificReferee
  end

  setup do
    using_shared_operation
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    @pipeline = SpecificPipeline.new(key_indicator_report)
  end

  test '.valid_input_data? returns true if requirements are satisfied' do
    assert_equal true, @pipeline.valid_input_data?
  end

  test '.require_fetcher? returns true if external data access is necessary' do
    assert_equal true, @pipeline.require_fetcher?
  end

  test '.call should run SpecificReferee' do
    SpecificReferee.any_instance.expects(:call)

    @pipeline.call
  end

  test '.call key_indicator_report should receive the result of the referee' do
    SpecificReferee.any_instance.expects(:call).returns(Risk::KeyIndicatorReport::GREEN_FLAG)
    @pipeline.call

    expected = {
      'referee_specific' => {
        title: 'Very Specific Referee',
        description: 'It judges things',
        flag: Risk::KeyIndicatorReport::GREEN_FLAG
      }
    }

    assert_equal expected, @pipeline.key_indicator_report.key_indicators
  end
end
