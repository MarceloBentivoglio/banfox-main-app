require 'test_helper'

class Risk::Service::SerasaTest < ActiveSupport::TestCase
  def mocked_cnpj
    @cnpj ||= CNPJ.generate
  end

  def subject
    Risk::Service::Serasa
  end

  def nogord_response
    file_data = File.open("#{Rails.root}/test/support/files/nogord_serasa_example.json").read
    JSON.parse(file_data)
  end

  test '.call' do
    Risk::Fetcher::NogordSerasa.expects(:call).returns(nogord_response)
    key_indicator_report = FactoryBot.create(:key_indicator_report)

    serasa_data = subject.call(key_indicator_report)
    assert_kind_of Risk::Entity::Serasa::CompanySummary, serasa_data[:summary]
  end
end
