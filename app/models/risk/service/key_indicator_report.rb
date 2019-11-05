module Risk
  module Service
    class KeyIndicatorReport
      attr_reader :key_indicator_report
      include CNPJFormatter
      TTL = 7.days

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      def self.call(key_indicator_report)
        KeyIndicatorReportJob.perform_later(key_indicator_report.id)
      end

      def self.process(key_indicator_report)
        case key_indicator_report.kind
        when 'new_cnpj'
          Risk::Service::NewCNPJStrategy.new.call(key_indicator_report)
        when 'recurrent_operation'
          Risk::Service::RecurrentOperationStrategy.new.call(key_indicator_report)
        end
      end
    end
  end
end
