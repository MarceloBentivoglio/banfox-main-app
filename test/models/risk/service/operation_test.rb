require 'test_helper'

class Risk::Service::OperationTest < ActiveSupport::TestCase
  class SpecificStrategy < Risk::Service::Operation
    pipeline_list Risk::Pipeline::Serasa
  end

  setup do
    Risk::Pipeline::Serasa.stubs(:fetchers).returns([Risk::Fetcher::Serasa])

    @subject = SpecificStrategy.new
    using_shared_operation
  end

  test '.call executes Service::ExternalDatum' do
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    Risk::Service::ExternalDatum.any_instance.expects(:call).once

    @subject.call(key_indicator_report)
  end

  test '.pipeline_list configures list of pipelines to be used' do
    assert_equal true, SpecificStrategy.pipelines.member?(Risk::Pipeline::Serasa)
  end

  test '.fetchers_required gets a list of fetchers required from pipelines' do
    strategy = SpecificStrategy.new
    assert_equal [Risk::Fetcher::Serasa], strategy.fetchers_required
  end
end
