module Risk

  module Referee
    class RefinValueDelta < Base
      include DeltaEvaluator

      # entities must be a chronological ordered array
      def initialize(evidences)
        @evidences = evidences
        @code = 'refin_value_delta'
        @title = 'Refin Value Delta'
        @description = 'Calculate delta of the value of refin'
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        current_value = @evidences.refin_value
        historic_value = @evidences.refin_historic_value
        evaluate_delta_for_negative_information(historic_value, current_value)
      end
    end
  end
end
