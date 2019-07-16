require 'test_helper'

module Risk
  module Fetcher
    class BigDataCorpTest < ActiveSupport::TestCase
      def cnpj
        @cnpj ||= CNPJ.generate
      end

      def invalid_cnpj
        "91458830091070"
      end

      test 'calls BigBoost API' do
        HTTParty.expects(:get).returns(true)

        Risk::Fetcher::BigDataCorp.new(cnpj: cnpj).company_basic_data.call
      end

      test 'do not call basic_data if cnpj is invalid' do
        HTTParty.expects(:get).never

        expected = false
        assert_equal expected, Risk::Fetcher::BigDataCorp.new(cnpj: invalid_cnpj).company_basic_data.call
      end
    end
  end
end
