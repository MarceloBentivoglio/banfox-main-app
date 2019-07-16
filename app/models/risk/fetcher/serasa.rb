module Risk
  module Fetcher
    class Serasa < Base
      attr_reader :key_indicator_report 

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def name
        'serasa_api'
      end

      def call
      end
    end
  end
end
