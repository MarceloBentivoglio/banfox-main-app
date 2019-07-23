module Risk
  module Fetcher
    class Serasa < Base

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
        @data = []
      end

      def name
        'serasa_api'
      end

      def http_method
        'post'
      end

      def headers
        nil
      end

      def payload(cnpj)
        {}
      end

      def username
        Rails.application.credentials[Rails.env.to_sym][:serasa][:username] unless Rails.env == 'test'
      end

      def password
        Rails.application.credentials[Rails.env.to_sym][:serasa][:password] unless Rails.env == 'test'
      end

      def call
        cnpj_to_search = []
        cnpj_to_search << @key_indicator_report&.input_data&.dig('seller')
        cnpj_to_search << @key_indicator_report&.input_data&.dig('payers')

        cnpj_to_search.flatten.uniq.each do |cnpj|
          http_call({}, target(cnpj), nil)
        end

        self
      end

      def needs_parsing?
        true
      end

      def parser
        @parser ||= Risk::Parser::Serasa.new
      end

      def serasa_request_string(cnpj)
        "#{username}#{password}        IP20NRRFS2        0#{cnpj}22N            233E 028                                                                                C66M                                                                                                                                                                                                                                                                                                                         S" 
      end

      def target(cnpj)
        return '' if cnpj.nil?
        sliced_cnpj = cnpj[0...8]
        if Rails.env == 'production'
          "https://sitenet43.serasa.com.br/Prod/consultahttps?p=#{serasa_request_string(sliced_cnpj)}"
        else
          "https://mqlinuxext.serasa.com.br/Homologa/consultahttps?p=#{serasa_request_string(sliced_cnpj)}"
        end
      end
    end
  end
end
