module Risk
  module Referee
    class CrossRefinQuantity < Base
      include DeltaEvaluator
      def initialize(evidence)
        @root_evidence = evidence.with_indifferent_access
        @evidence = {
          refin_value_delta: @root_evidence[:refin_value_delta],
          refin_quantity_delta: @root_evidence[:refin_quantity_delta]
        }.with_indifferent_access

        @code = 'cross_refin_quantity'
        @title = 'Cross Refin Quantity'
        @description = ''
        @params = {
          green_limit: 0.1
        }
      end

      def assert
        if @evidence[:refin_quantity_delta]['flag'] == Risk::KeyIndicatorReport::RED_FLAG
          return Risk::KeyIndicatorReport::YELLOW_FLAG 
        elsif @evidence[:refin_quantity_delta]['flag'] == Risk::KeyIndicatorReport::GREEN_FLAG
          return Risk::KeyIndicatorReport::GREEN_FLAG
        else
          value_delta = delta(
            @evidence.dig(:refin_value_delta, :evidence, :historic_quantity),
            @evidence.dig(:refin_value_delta, :evidence, :current_quantity)
          )

          if value_delta <= @params[:green_limit]
            @evidence[:refin_quantity_delta]['ignored'] = true
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
