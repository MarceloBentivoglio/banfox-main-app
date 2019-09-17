module Risk
  module Referee
    class CrossRefinValue < Base
      include DeltaEvaluator
      def initialize(evidence)
        @root_evidence = evidence.with_indifferent_access
        @evidence = {
          refin_value_delta: @root_evidence[:refin_value_delta],
          refin_quantity_delta: @root_evidence[:refin_quantity_delta]
        }.with_indifferent_access

        @code = 'cross_refin_value'
        @title = 'Cross Refin Value'
        @description = ''
        @params = {
          green_limit: 0.1
        }
      end

      def assert
        return Risk::KeyIndicatorReport::GRAY_FLAG if @evidence[:refin_value_delta].nil? || @evidence[:refin_quantity_delta].nil?

        if @evidence[:refin_value_delta]['flag'] == Risk::KeyIndicatorReport::RED_FLAG
          return Risk::KeyIndicatorReport::YELLOW_FLAG 
        elsif @evidence[:refin_value_delta]['flag'] == Risk::KeyIndicatorReport::GREEN_FLAG
          return Risk::KeyIndicatorReport::GREEN_FLAG
        else
          quantity_delta = delta(
            @evidence.dig(:refin_quantity_delta, :evidence, :historic_quantity),
            @evidence.dig(:refin_quantity_delta, :evidence, :current_quantity)
          )

          if quantity_delta <= @params[:green_limit]
            @evidence[:refin_value_delta]['ignored'] = true
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end

    end
  end
end
