module Risk
  module Referee
    class PartnerPefinQuantityDelta < Base
      include DeltaEvaluator

      def initialize(evidence)
        @collection_evidence = evidence.partner_data
        @code = 'partner_pefin_quantity_delta'
        @title = 'Partner Pefin Quantity Delta'
        @description = ''
        @params = { green_limit: 0, yellow_limit: 0.5 }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            historic: evidence.pefin_historic_quantity,
            current: evidence.pefin_quantity,
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
