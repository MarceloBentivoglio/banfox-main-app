module Risk
  module Referee
    class RefinQuantityDelta < Base
      include DeltaEvaluator
      # entities must be a chronological ordered array
      # entities must have @type Risk::Entity::Serasa::CompanySummary
      def initialize(key_indicator_factory, company_summaries=[])
        @key_indicator_factory = key_indicator_factory
        @entities = company_summaries
        @code = ''
        @title = ''
        @description = ''
        @params = {green_limit: 0, yellow_limit: 0.5}
      end

      def call
        historic_quantity = @entities.first.refin[:quantity]
        current_quantity = @entities.last.refin[:quantity]
        evaluate_delta_for_negative_information(historic_quantity, current_quantity)
      end
    end
  end
end
