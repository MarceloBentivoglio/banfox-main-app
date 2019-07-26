module Risk
  module Referee
    class PefinValueDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidences)
        @evidences = evidences
        @code = ''
        @title = ''
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        historic_value = @evidences.pefin_historic_value
        current_value  = @evidences.pefin_value
        evaluate_delta_for_negative_information(historic_value, current_value)
      end
    end
  end
end
