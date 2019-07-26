module Risk
  module Referee
    class ProtestValueDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidences)
        @evidences = evidences
        @code = 'protest_value_delta'
        @title = 'Protest Value Delta'
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        historic_value = @evidences.protest_historic_value
        current_value  = @evidences.protest_value
        evaluate_delta_for_negative_information(historic_value, current_value)
      end
    end
  end
end
