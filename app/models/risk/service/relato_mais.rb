module Risk
  module Service
    class RelatoMais
      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def call
        fetcher = Risk::Fetcher::Serasa.new(@key_indicator_report)
        external_data = Risk::Service::ExternalDatum.new(fetcher, @key_indicator_report).call

        parsed_data = external_data.map do |datum|
          Risk::Parser::Serasa.new(datum.raw_data).call
        end

        entities = parsed_data.map do |datum|
          Risk::Deserializer::Serasa.new(datum).call
        end
      end
    end
  end
end
