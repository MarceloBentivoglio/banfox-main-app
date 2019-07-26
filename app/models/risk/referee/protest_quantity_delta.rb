module Risk
  module Referee
    class ProtestQuantityDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidences)
        @evidences = evidences
        @code = 'protest_quantity_delta'
        @title = 'Protest Quantity Delta'
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        historic_quantity = @evidences.protest_historic_quantity
        current_quantity  = @evidences.protest_quantity
        evaluate_delta_for_negative_information(historic_quantity, current_quantity)
      end
    end
  end
end
