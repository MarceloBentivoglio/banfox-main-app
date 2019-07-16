module Risk
  module Service
    class Serasa
      attr_reader :key_indicator_report
      
      def self.call(key_indicator_report)
        new(key_indicator_report).call
      end

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def call
        begin
          external_data = fetch_data(key_indicator_report.input_data[:cnpj])
          unless external_data.nil?
            deserialized_data = Risk::Deserializer::NogordSerasa.new(external_data).call
          end

          #Start Pipeline
        rescue Exception => e
          ::Rollbar.error(e, 'Error trying to deserialize nogord serasa response')
        else
          return deserialized_data
        end

        false
      end

      def fetch_data(cnpj)
        begin
          @data ||= Risk::Fetcher::NogordSerasa.call(cnpj)
          external_source_data = @data['info']['external_sources'].first['data']

        rescue Exception => e
          Rollbar.error(e, 'Error calling Risk::Fetcher::NogordSerasa')
        else
          return external_source_data
        end

        nil
      end
    end
  end
end
