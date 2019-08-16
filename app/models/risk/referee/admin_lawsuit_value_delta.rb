module Risk
  module Referee
    class AdminLawsuitValueDelta < Base
      include DeltaEvaluator

      def initialize(evidence)
        @collection_evidence = evidence.admin_data
        @code = 'admin_lawsuit_value_delta'
        @title = 'Admin Lawsuit Value Delta'
        @description = ''
        @params = { green_limit: 0, yellow_limit: 0.5 }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            historic: evidence.lawsuit_historic_value,
            current: evidence.lawsuit_value,
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
