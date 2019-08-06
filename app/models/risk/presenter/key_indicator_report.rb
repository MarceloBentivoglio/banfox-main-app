module Risk
  module Presenter
    class KeyIndicatorReport < SimpleDelegator
      attr_reader :key_indicator_report

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
        __setobj__(key_indicator_report)
      end

      def key_indicators
        @key_indicator_report.key_indicators.map do |cnpj, key_indicators|
          {
            cnpj: CNPJ.new(cnpj).formatted,
            conclusion: conclusion
          }
        end
      end

      def conclusions
        @key_indicator_report.key_indicators.map do |cnpj, key_indicators|
          count_flags = {
            cnpj: CNPJ.new(cnpj).formatted,
            flags: {
              gray: 0,
              green: 0,
              yellow: 0,
              red: 0
            }
          }

          key_indicators.each do |_, key_indicator|
            case key_indicator['flag']
            when -1
              count_flags[:flags][:gray] += 1
            when 0
              count_flags[:flags][:green] += 1
            when 1
              count_flags[:flags][:yellow] += 1
            when 2
              count_flags[:flags][:red] += 1
            end
          end

          count_flags
        end
      end
    end
  end
end