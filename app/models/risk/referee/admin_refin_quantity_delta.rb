module Risk
  module Referee
    class AdminRefinQuantityDelta < Base
      include DeltaEvaluator

      def initialize(evidence)
        @collection_evidence = evidence.admin_data
        @code = 'admin_refin_quantity_delta'
        @title = 'Admin Refin Quantity Delta'
        @description = ''
        @params = { green_limit: 0, yellow_limit: 0.5 }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            historic: evidence.refin_historic_quantity,
            current: evidence.refin_quantity,
            cpf: evidence.partner_document,
            name: evidence.partner_name
          }

          code = "#{@code}_#{evidence.partner_document}"

          {
            code: code,
            title: @title,
            description: evidence.partner_document,
            params: @params,
            evidence: @evidence,
            flag: assert
          }
        end
      end

      def assert
        evaluate_delta_for_negative_information(
          @evidence[:historic],
          @evidence[:current]
        )
      end

      def multiple_assertions?
        true
      end
    end
  end
end
