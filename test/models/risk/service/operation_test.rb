require 'test_helper'

class Risk::Service::OperationTest < ActiveSupport::TestCase
  class SpecificStrategy < Risk::Service::Operation
    pipeline_list Risk::Pipeline::Serasa
  end

  setup do
    Risk::Pipeline::Serasa.stubs(:fetchers).returns([Risk::Fetcher::Serasa])
    Risk::Fetcher::Serasa.any_instance.stubs(:call)

    @subject = SpecificStrategy.new
    using_shared_operation
  end

  test '.pipeline_list configures list of pipelines to be used' do
    assert_equal true, SpecificStrategy.pipelines.member?(Risk::Pipeline::Serasa)
  end

  test '.fetchers_required gets a list of fetchers required from pipelines' do
    strategy = SpecificStrategy.new
    assert_equal [Risk::Fetcher::Serasa], strategy.fetchers_required
  end

  test '.call persists AnalyzedPart' do
    Risk::Referee::RefinValueDelta.any_instance.expects(:call).returns(Risk::KeyIndicatorReport::GRAY_FLAG)
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    @subject.call(key_indicator_report)

    assert_equal 3, key_indicator_report.analyzed_parts.count
  end
end
