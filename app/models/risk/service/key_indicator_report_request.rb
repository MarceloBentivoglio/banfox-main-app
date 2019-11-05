module Risk
  module Service
    class KeyIndicatorReportRequest 
      def self.call(params)
        if params.keys.member?(:cnpjs) &&
           params.keys.member?(:operation_id)

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
                                                         input_data: params[:cnpjs]
                                                        )

        reports = params[:cnpjs].map do |cnpj|
          cnpj = CNPJ.new(cnpj).stripped
          historic = historic_of_last_operation(cnpj)
          kind = historic.nil? ? 'new_cnpj' : 'recurrent_operation'
          Risk::KeyIndicatorReport.create(cnpj: cnpj,
                                          key_indicator_report_request_id: request.id,
                                          kind: kind,
                                          ttl: DateTime.now + 7.days,
                                          operation_id: params[:operation_id],
                                          historic: JSON.generate(historic))
        end

        reports.each do |report|
          Risk::Service::KeyIndicatorReport.call(report)
        end

        request
      end

      def historic_of_last_operation(cnpj)
        shortened_cnpj = cnpj[0..7]
        last_operation = Operation.joins(:installments, invoices: [:payer, :seller])
                                    .where('installments.backoffice_status': ['approved' , 'deposited'])
                                    .where('invoices.seller': identify_part(cnpj)&.id)
                                    .where('sellers.id=? OR payers.id=?', identify_part(cnpj)&.id, identify_part(cnpj)&.id)
                                    .last

        last_operation&.key_indicator_reports
                      &.select {|kir| kir.cnpj == cnpj }
                      &.first
                      &.evidences
                      &.dig('serasa_api', shortened_cnpj)
                      &.select {|evidence| !evidence.nil?}
      end

      def identify_part(cnpj)
        sellers = Seller.where(cnpj: cnpj)
        if sellers.any?
          return sellers.first
        end

        payers = Payer.where(cnpj: cnpj)
        return payers.first if payers.any?

        nil
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
