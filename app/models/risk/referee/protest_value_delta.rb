module Risk
  module Referee
    class ProtestValueDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidence)
        @evidence = {
          historic_value: evidence.protest_historic_value,
          current_value:  evidence.protest_value
        }
        @code = 'protest_value_delta'
        @title = 'Protest Value Delta'
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
