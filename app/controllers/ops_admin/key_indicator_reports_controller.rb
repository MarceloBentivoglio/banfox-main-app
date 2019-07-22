module OpsAdmin
  class KeyIndicatorReportsController < OpsAdmin::BaseController
    def create
      operation = Operation.find(params.dig :operation_id)

      kind = params.dig(:kind)

      input_data = {
        payers: operation.payers.map {|payer| payer.cnpj},
        seller: operation.seller.cnpj,
      }

      key_indicator_report = Risk::Service::KeyIndicatorReport.new(input_data, kind, Time.now + 1.day)
                                                              .call(operation)
      key_indicator_report.save

      redirect_to ops_admin_operations_analyse_path
    end
  end
end
