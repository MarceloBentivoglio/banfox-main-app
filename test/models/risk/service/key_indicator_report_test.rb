require 'test_helper'

class Risk::Service::KeyIndicatorReportTest < ActiveSupport::TestCase
  setup do
    DateTime.stubs(:now).returns(DateTime.new(2019, 2, 3))
    @input_data = { cnpj: "00310523911323" }
    @kind = 'operation_part'
    @ttl = DateTime.new(2019,2,3)


    @subject = Risk::Service::KeyIndicatorReport.new(@input_data, @kind, @ttl)
  end

  test '.call returns a cached key_indicator_report if ttl is nonexpired' do

    @key_indicator_report = Risk::KeyIndicatorReport.new
    @key_indicator_report.input_data = @input_data
    @key_indicator_report.ttl = @ttl
    @key_indicator_report.kind = @kind
    @key_indicator_report.save

    assert_equal @key_indicator_report, @subject.call
  end

  test '.call executes the correct strategy' do
    key_indicator_report = FactoryBot.build(:key_indicator_report)
    key_indicator_report.ttl = (@ttl - 1.day)
    key_indicator_report.save

    Risk::Service::OperationPartStrategy.any_instance.expects(:call)

    @subject.call
  end
end
