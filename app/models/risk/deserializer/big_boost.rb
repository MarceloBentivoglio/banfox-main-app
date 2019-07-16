module Risk
  module Deserializer
    class BigBoost
      def self.call(data)
        new(data).call
      end

      def initialize(data={})
        @data = data
      end

      def call
        Risk::Entity::Company.new
      end

      def map_attributes_as_hash
        {
          official_name: @data[]
        }
      end

      def data
        basic_data ||= @data&.with_indifferent_access[:Result]&.first[:BasicData]
        return {} if basic_data.nil?

        basic_data
      end

      def official_name
        data[:OfficialName]
      end

      def trade_name
        data[:TradeName]
      end

      def tax_origin
        data[:TaxIdOrigin]
      end

      def tax_status
        data[:TaxIdStatus]
      end

      def founded_date
        DateTime.strptime(data[:FoundedDate]).to_date
      end
    end
  end
end
