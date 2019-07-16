module Risk
  module Fetcher
    class BigDataCorp
      attr_reader :cnpj, :access_token, :params

      def self.call(cnpj)
        new(cnpj)
      end

      def initialize(params)
        @params = params.with_indifferent_access
        @query = {
          'AccessToken' => Rails.application.credentials.big_boost_api_token
        }
      end

      def invalid_params!
        @invalid_params = true
      end

      def company_basic_data
        invalid_params! unless CNPJ.valid?(@params[:cnpj])
        @query = {
          'Datasets' => 'basic_data',
          'q' => "doc{#{cnpj}}",
        }
        self
      end

      def call
        return false if @invalid_params
        headers = {
          'Content-Type' => 'application/json'
        }

        HTTParty.get(
          'https://bigboost.bigdatacorp.com.br/companies',
          query: @query,
          headers: headers
        )
      end
    end
  end
end
