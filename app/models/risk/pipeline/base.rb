module Risk
  module Pipeline
    class Base
      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      class << self
        attr_reader :params, :fetchers

        def required_params(*params)
          @params = params
        end

        def fetch_from(*fetchers)
          @fetchers = fetchers
        end
      end
      
      def valid_input_data?
        self.class.params.reduce(false)  do |valid, key|
          @key_indicator_report.input_data.has_key?(key.to_s)
        end
      end

      def require_fetcher?
        self.class.fetchers.any?
      end
    end
  end
end
