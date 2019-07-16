require 'test_helper'

class Risk::Service::ExternalDatumTest < ActiveSupport::TestCase
  class TestFetcher
    def initialize(key_indicator_report)
    end

    def self.name
      'test_source'
    end

    def self.call(*)
      {
        very_important_data: 1
      }
    end

    def needs_parsing?
      false
    end
  end


  test '.call returns cached external_datum' do
    cached_external_datum = FactoryBot.create(:external_datum)
    key_indicator_report = FactoryBot.create(:key_indicator_report)

    Risk::ExternalDatum.expects(:create).never

    external_datum = Risk::Service::ExternalDatum.new(
      TestFetcher,
      key_indicator_report
    ).call

    assert_equal cached_external_datum, external_datum
  end

  test '.call calls fetcher if ttl is expired' do
    expired_external_datum = FactoryBot.create(:external_datum, :expired_ttl)
    key_indicator_report = FactoryBot.create(:key_indicator_report)

    TestFetcher.expects(:call).returns({ very_important_data: 1})

    assert_difference 'Risk::ExternalDatum.count' do
      external_datum = Risk::Service::ExternalDatum.new(
        TestFetcher, 
        key_indicator_report
      ).call
    end
  end

  test '.call attaches external data into the given key indicator report' do
    key_indicator_report = FactoryBot.create(:key_indicator_report)
    external_datum = Risk::Service::ExternalDatum.new(
      TestFetcher, 
      key_indicator_report
    ).call

    assert_equal 1, key_indicator_report.external_data.count
    assert_equal 1, external_datum.key_indicator_reports.count
  end

  test '.call parses external data if needed' do
    TestFetcher.any_instance.expects(:needs_parsing?).returns(true)
    TestFetcher.any_instance.expects(:parser).returns(stub({raw_data: {}, call: true }))

    key_indicator_report = FactoryBot.create(:key_indicator_report)
    external_datum = Risk::Service::ExternalDatum.new(
      TestFetcher, 
      key_indicator_report
    ).call
  end
end
