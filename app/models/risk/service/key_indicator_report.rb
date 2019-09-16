module Risk
  module Service
    class KeyIndicatorReport
      include CNPJFormatter
      #ttl in minutes
      def initialize(params, ttl)
        @params = params
        @ttl = ttl
        @errors = []
      end

      #TODO add a new status to know if key_indicator_report is ready
      def call
        key_indicator_report = build_key_indicator_report
        #KeyIndicatorReportJob.perform_later(key_indicator_report.id) unless @errors.any?
        Risk::Service::KeyIndicatorReport.process(key_indicator_report)

        key_indicator_report
      end

      def async_call
        key_indicator_report = build_key_indicator_report
        KeyIndicatorReportJob.perform_later(key_indicator_report.id) unless @errors.any?

        key_indicator_report
      end

      def build_key_indicator_report
        if operation.nil?
          params = query_params
        else
          params = operation_params(operation)
        end

        if @errors.any?
          key_indicator_report = Risk::KeyIndicatorReport.new
          @errors.each do |error_message|
            key_indicator_report.errors.add :input_data, message: error_message
          end
        else
          key_indicator_report = Risk::KeyIndicatorReport.create(params)

          params[:input_data].each do |cnpj|
            key_indicator_report.key_indicators[cnpj_root_format(cnpj)] = {}
          end
          #This will become a asynchronous worker
          #service_strategy.call(key_indicator_report)
        end

        key_indicator_report
      end

      def self.process(key_indicator_report)
        service_strategy(key_indicator_report)
      end

      def self.service_strategy(key_indicator_report)
        case key_indicator_report.kind
        when 'new_cnpj'
          Risk::Service::NewCNPJStrategy.new.call(key_indicator_report)
        when 'recurrent_operation'
          Risk::Service::RecurrentOperationStrategy.new.call(key_indicator_report)
        end
      end

      def operation
        return nil if @params[:operation_id].nil?
        ::Operation.find @params[:operation_id]
      end

      def operation_params(operation)
        input_data = []
        input_data << operation.seller.cnpj
        operation.payers.each do |payer|
          input_data << payer.cnpj
        end

        {
          input_data: input_data,
          kind: @params[:kind],
          ttl: @ttl,
          operation_id: operation.id,
        }
      end

      def query_params
        query = @params[:risk_key_indicator_report][:input_data].split(',')

        query.each do |cnpj|
          if !CNPJ.new(cnpj).valid?
            @errors << cnpj
          end
        end

        {
          input_data: query,
          kind: @params[:kind],
          ttl: @ttl
        }
      end

      def service_strategy
        case @params[:kind]
        when 'new_cnpj'
          Risk::Service::NewCNPJStrategy.new
        when 'recurrent_operation'
          Risk::Service::RecurrentOperationStrategy.new
        end
      end
    end
  end
end
