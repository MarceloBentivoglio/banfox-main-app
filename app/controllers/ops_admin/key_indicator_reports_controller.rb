module OpsAdmin
  class KeyIndicatorReportsController < OpsAdmin::BaseController
    def create
      operation = Operation.find(params.dig :operation_id)
      kind = params.dig(:kind)

      input_data = {
        payers: operation.payers.map {|payer| payer.cnpj},
        seller: operation.seller.cnpj,
      }

      key_indicator_report = Risk::KeyIndicatorReport.create(
        input_data: input_data,
        kind: kind
      )

      Risk::Service::KeyIndicatorReport.new(key_indicator_report, kind, Time.now + 1.day).call
    end
  end
end
