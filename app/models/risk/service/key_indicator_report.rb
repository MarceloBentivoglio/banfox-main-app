module Risk
  module Service
    class KeyIndicatorReport
      attr_reader :operation

      #ttl in minutes
      def initialize(input_data = {}, kind, ttl)
        @input_data = input_data
        @kind = kind
        @ttl = ttl
      end

      #TODO add a new status to know if key_indicator_report is ready
      def call(operation)
        nonexpired_reports = Risk::KeyIndicatorReport.where(operation_id: operation.id)
                                                     .where('ttl >= ?', DateTime.now)

        return nonexpired_reports.last if nonexpired_reports.any?

        key_indicator_report = Risk::KeyIndicatorReport.create(
          input_data: @input_data,
          kind: @kind,
          ttl: @ttl,
          operation_id: operation.id
        )

        #This will become a asynchronous worker
        service_strategy.call(key_indicator_report)

        key_indicator_report
      end

      def service_strategy
        case @kind
        when 'operation_part'
          Risk::Service::OperationPartStrategy.new
        when 'recurrent_operation'
          Risk::Service::RecurrentOperationStrategy.new
        end
      end
    end
  end
end
