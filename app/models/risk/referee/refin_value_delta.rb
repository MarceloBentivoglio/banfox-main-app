module Risk
  module Referee
    class RefinValueDelta < Base
      include DeltaEvaluator

      # entities must be a chronological ordered array
      def initialize(evidence)
        @evidence = {
          current_value:  evidence.refin_value,
          historic_value: evidence.refin_historic_value
        }
        @code = 'refin_value_delta'
        @title = 'Refin Value Delta'
        @description = 'Calculate delta of the value of refin'
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
