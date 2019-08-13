require 'test_helper'

class Risk::Service::ExternalDatumTest < ActiveSupport::TestCase
  class TestFetcher
    attr_accessor :data
    def initialize(key_indicator_report)
    end

    def name
      'test_source'
    end

    def call(*)
      {
        very_important_data: 1
      }
    end

    def needs_parsing?
      false
    end
  end

  def setup
    using_shared_operation
  end

  test '.call calls fetcher if ttl is expired' do
    expired_external_datum = FactoryBot.create(:external_datum, :expired_ttl)
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)

    TestFetcher.any_instance.expects(:call).returns({ very_important_data: 1})

    assert_difference 'Risk::ExternalDatum.count' do
      external_datum = Risk::Service::ExternalDatum.new(
        TestFetcher, 
        key_indicator_report
      ).call
    end
  end

  test '.call do not call fetcher if ttl is not expired' do
    FactoryBot.create(:external_datum)
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)

    TestFetcher.any_instance.expects(:call).never

    Risk::Service::ExternalDatum.new(
      TestFetcher,
      key_indicator_report
    ).call

    assert_equal 1, Risk::ExternalDatum.count
  end

  test '.call attaches external data into the given key indicator report' do
    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    external_datum = Risk::Service::ExternalDatum.new(
      TestFetcher, 
      key_indicator_report
    ).call

    assert_equal 1, key_indicator_report.external_data.count
  end


  test '.call parses external data if needed' do
    TestFetcher.any_instance.expects(:needs_parsing?).returns(true)
    TestFetcher.any_instance.expects(:parser).returns(stub({raw_data: {}, call: true }))

    key_indicator_report = FactoryBot.create(:key_indicator_report, operation_id: @operation.id)
    external_datum = Risk::Service::ExternalDatum.new(
      TestFetcher, 
      key_indicator_report
    ).call
  end
end
