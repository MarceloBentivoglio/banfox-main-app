module Risk
  module Referee
    class PartnerRefinValueDelta < Base
      include DeltaEvaluator

      def initialize(evidence)
        @collection_evidence = evidence.partner_data
        @code = 'partner_refin_value_delta'
        @title = 'Partner Refin Value Delta'
        @description = ''
        @params = { green_limit: 0, yellow_limit: 0.5 }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            historic: evidence.refin_historic_value,
            current: evidence.refin_value,
            document: evidence.partner_document,
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
