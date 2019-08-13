require 'test_helper'

class Risk::Service::KeyIndicatorReportTest < ActiveSupport::TestCase
  setup do
    using_shared_operation
    DateTime.stubs(:now).returns(DateTime.new(2019, 2, 3))
    @params = {
      key_risk_indicator_report: {
        input_data: [
          "08728220000148",
          "16532989000114",
        ]
      },
      kind: 'recurrent_operation',
      operation_id: @operation.id
    }.with_indifferent_access

    @ttl = DateTime.new(2019,2,3)

    @subject = Risk::Service::KeyIndicatorReport.new(@params, @ttl)

    Risk::Fetcher::Serasa.any_instance.stubs(:http_call).returns('')

  end

  test '.call executes the correct strategy' do
    key_indicator_report = FactoryBot.build(:key_indicator_report)
    key_indicator_report.ttl = (@ttl - 1.day)
    key_indicator_report.save

    Risk::Service::RecurrentOperationStrategy.any_instance.expects(:call)

    @subject.call
  end

  test '.call executes operation_adapter when it receives a operation_id' do
    key_indicator_report = FactoryBot.build(:key_indicator_report)
    key_indicator_report.ttl = (@ttl - 1.day)
    key_indicator_report.save

    @subject.call
  end
end
