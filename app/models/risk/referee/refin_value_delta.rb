module Risk
  module Referee
    class RefinValueDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(evidences)
        @key_indicator_factory = key_indicator_factory
        @entities = company_summaries
        @code = 'refin_value_delta'
        @title = 'refin_value_delta'
        @description = 'Calculate delta of the value of refin'
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        historic_value = @entities.first.refin[:value]
        current_value = @entities.last.refin[:value]
        evaluate_delta_for_negative_information(historic_value, current_value)
      end
    end
  end
end
