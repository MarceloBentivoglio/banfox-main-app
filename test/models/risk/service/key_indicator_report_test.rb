require 'test_helper'

class Risk::Service::KeyIndicatorReportTest < ActiveSupport::TestCase
  setup do
    DateTime.stubs(:now).returns(DateTime.new(2019, 2, 3))
    @input_data = { cnpj: "00310523911323" }
    @kind = 'recurrent_operation'
    @ttl = DateTime.new(2019,2,3)

    @subject = Risk::Service::KeyIndicatorReport.new(@input_data, @kind, @ttl)

    Risk::Fetcher::Serasa.any_instance.stubs(:http_call).returns('')

    using_shared_operation
  end

  test '.call executes the correct strategy' do
    key_indicator_report = FactoryBot.build(:key_indicator_report)
    key_indicator_report.ttl = (@ttl - 1.day)
    key_indicator_report.save

    Risk::Service::RecurrentOperationStrategy.any_instance.expects(:call)

    @subject.call(@operation)
  end
end
