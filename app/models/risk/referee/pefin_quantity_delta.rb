module Risk
  module Referee
    class PefinQuantityDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidence)
        @evidence = { 
          historic_quantity: evidence.pefin_historic_quantity,
          current_quantity: evidence.pefin_quantity
        }

        @code = 'pefin_quantity_delta'
        @title = 'Pefin Quantity Delta'
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        evaluate_delta_for_negative_information(
          @evidence[:historic_quantity],
          @evidence[:current_quantity]
        )
      end
    end
  end
end
