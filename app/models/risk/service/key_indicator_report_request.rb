module Risk
  module Service
    class KeyIndicatorReportRequest 
      def self.call(params)
        if params.keys.member?(:cnpjs) &&
           params.keys.member?(:operation_id) &&
           params.keys.member?(:kind)

          if params[:cnpjs].nil?
            operation = Operation.find(params[:operation_id])
            params[:cnpjs] = [operation.seller.cnpj, operation.payers.map {|payer| payer.cnpj}].flatten
          end
          
          new.call params if validate_input_data(params)
        else
          raise 'cnpjs, operation_id or report_kind was not passed during KeyIndicatorReportRequest call'
        end
      end

      def call(params)
        request = Risk::KeyIndicatorReportRequest.create(operation_id: params[:operation_id],
                                                         input_data: params[:cnpjs],
                                                         kind: params[:kind]
                                                        )
        
        reports = params[:cnpjs].map do |cnpj|
          Risk::KeyIndicatorReport.create(cnpj: cnpj,
                                          key_indicator_report_request_id: request.id,
                                          kind: params[:kind],
                                          ttl: DateTime.now + 7.days,
                                          operation_id: params[:operation_id])
        end

        reports.each do |report|
          Risk::Service::KeyIndicatorReport.call(report)
        end

        request
      end

      def self.validate_input_data(params)
        invalid_cnpjs = []
        params[:cnpjs].each do |cnpj|
          invalid_cnpjs << cnpj unless CNPJ.new(cnpj).valid?
        end

        if invalid_cnpjs.any?
          raise "Wrong format found in CNPJs: #{invalid_cnpjs}"
        end

        true
      end
    end
  end
end
