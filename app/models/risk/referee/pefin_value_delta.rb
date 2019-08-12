module Risk
  module Referee
    class PefinValueDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidence)
        @evidence = {
          historic_value: evidence.pefin_historic_value,
          current_value:  evidence.pefin_value
        }

        @code = 'pefin_value_delta'
        @title = 'Pefin Value Delta'
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def assert
        evaluate_delta_for_negative_information(
          @evidence[:historic_value],
          @evidence[:current_value]
        )
      end
    end
  end
end
