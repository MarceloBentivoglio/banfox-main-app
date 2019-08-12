module Risk
  module Referee
    class ProtestQuantityDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidence)
        @evidence = {
          historic_quantity: evidence.protest_historic_quantity,
          current_quantity:  evidence.protest_quantity
        }

        @code = 'protest_quantity_delta'
        @title = 'Protest Quantity Delta'
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def assert
        evaluate_delta_for_negative_information(
          @evidence[:historic_quantity],
          @evidence[:current_quantity]
        )
      end
    end
  end
end
