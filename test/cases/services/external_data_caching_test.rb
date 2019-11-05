require 'test_helper'

class ExternalDataCachingTest < ActiveSupport::TestCase
  setup do
    @external_data_serasa = FactoryBot.create(:external_datum, :serasa_diadema)
    @external_data_serasa.ttl = DateTime.current + 1.day

    @key_indicator_report = Risk::KeyIndicatorReport.new(cnpj: "09003947692413")
  end

  test 'Do not call fetcher class if TTL is still valid ' do
    Risk::Service::ExternalDatum.any_instance
                                .stubs(:cached_data)
                                .returns([@external_data_serasa])

    Risk::Fetcher::Serasa.any_instance.expects(:call).never

    Risk::Service::ExternalDatum.new(Risk::Fetcher::Serasa,  @key_indicator_report).call
  end
end
