module Risk
  module Referee
    class PartnerLawsuitValueDelta < Base
      include DeltaEvaluator

      def initialize(evidence)
        @collection_evidence = evidence.partner_data
        @code = 'partner_lawsuit_value_delta'
        @title = 'Partner Lawsuit Value Delta'
        @description = ''
        @params = { green_limit: 0, yellow_limit: 0.5 }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            historic: evidence.lawsuit_historic_value,
            current: evidence.lawsuit_value,
            cpf: evidence.partner_cpf,
            name: evidence.partner_name
          }

          code = "#{@code}_#{evidence.partner_cpf}"

          {
            code: code,
            title: @title,
            description: evidence.partner_cpf,
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
    end
  end
end
