module Risk
  module Fetcher
    class BigDataCorp
      attr_reader :cnpj, :access_token, :params, :key_indicator_report, :data

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def query
        {
          'AccessToken' => 'fe98abc7-bb6a-4f4a-90ba-33577d713d86'
        }
      end

      def name
        'big_data_corp'
      end

      def cache_query_key
        @query
      end

      def invalid_params!
        @invalid_params = true
      end

      def company_basic_data_query
        basic_data_query = query
        basic_data_query['Datasets'] = 'basic_data,economic_group_data'
        basic_data_query['q'] = "doc{#{key_indicator_report.cnpj}}"

        basic_data_query
      end

      def headers
        {
          'Content-Type' => 'application/json'
        }
      end

      def call
        return false if @invalid_params
        
        @company_response = HTTParty.get(
          'https://bigboost.bigdatacorp.com.br/companies',
          query: company_basic_data_query,
          headers: headers
        ).body

        partners = fetch_partners
        if partners&.any?
          partner_response = JSON.parse(partners.first)
        else
          partner_response = {}
        end

        @data = {
          companies: JSON.parse(@company_response),
          partners: partner_response
        }
      end

      def needs_parsing?
        false
      end

      def fetch_partners
        get_all_partners.map do |cpf|
          HTTParty.get(
            'https://bigboost.bigdatacorp.com.br/peoplev2',
            query: partner_data_query(complete_cpf(cpf)),
            headers: headers
          ).body
        end
      end

      def partner_data_query(cpf)
        basic_data_query = query
        basic_data_query['Datasets'] = 'basic_data,financial_data,business_relationships'
        basic_data_query['q'] = "doc{#{cpf}}"

        basic_data_query
      end

      def get_all_partners
        serasa_key = key_indicator_report.evidences['serasa_api'].keys.first
        partner_documents = key_indicator_report.evidences.dig('serasa_api', serasa_key, 'partner_documents')

        return [] unless partner_documents&.any?

        partner_documents.select {|partner| partner['pf_or_pj'] == 'F' } 
                         .map {|partner| partner['cpf_or_cnpj'] }
      end

      def complete_cpf(cpf)
        cpf = cpf.split('').map {|digit| digit.to_i }
        cpf << CPF::VerifierDigit.generate(cpf)
        cpf << CPF::VerifierDigit.generate(cpf)

        cpf = CPF.new(cpf.map {|digit| digit.to_s }.join)

        cpf.formatted
      end
    end
  end
end
