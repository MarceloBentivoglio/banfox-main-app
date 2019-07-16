require 'test_helper'

class Risk::Service::RelatoMaisTest < ActiveSupport::TestCase
  def setup
    @subject ||= Risk::Service::RelatoMais.new(key_indicator_report)
  end

  def key_indicator_report
    @key_indicator_report ||= FactoryBot.create(:key_indicator_report)
  end

  def external_data
    @external_data ||= FactoryBot.create(:external_datum, :serasa)
  end

  test '.call fetches external data' do
    Risk::Service::ExternalDatum.any_instance
                                .expects(:call)
                                .returns([external_data])

    @subject.call
  end
end
