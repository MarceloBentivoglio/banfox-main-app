module Risk
  module Fetcher
    class Base
      attr_reader :key_indicator_report

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end
    end
  end
end
