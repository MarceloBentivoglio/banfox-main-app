module Risk
  module Decorator
    class KeyIndicatorReport
      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def each_cnpj
        @key_indicator_report.key_indicators.each do |cnpj, key_indicators|
          yield cnpj, key_indicators
        end
      end
    end
  end
end
