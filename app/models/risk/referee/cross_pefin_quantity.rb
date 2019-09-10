module Risk
  module Referee
    class CrossPefinQuantity < Base
      include DeltaEvaluator
      def initialize(evidence)
        @root_evidence = evidence.with_indifferent_access
        @evidence = {
          pefin_value_delta: @root_evidence[:pefin_value_delta],
          pefin_quantity_delta: @root_evidence[:pefin_quantity_delta]
        }.with_indifferent_access

        @code = 'cross_pefin_quantity'
        @title = 'Cross Pefin Quantity'
        @description = ''
        @params = {
          green_limit: 0.1
        }
      end

      def assert
        return Risk::KeyIndicatorReport::GRAY_FLAG if @evidence[:pefin_value_delta].nil? || @evidence[:pefin_quantity_delta].nil?

        if @evidence[:pefin_quantity_delta]['flag'] == Risk::KeyIndicatorReport::RED_FLAG
          return Risk::KeyIndicatorReport::YELLOW_FLAG 
        elsif @evidence[:pefin_quantity_delta]['flag'] == Risk::KeyIndicatorReport::GREEN_FLAG
          return Risk::KeyIndicatorReport::GREEN_FLAG
        else
          value_delta = delta(
            @evidence.dig(:pefin_value_delta, :evidence, :historic_quantity),
            @evidence.dig(:pefin_value_delta, :evidence, :current_quantity)
          )

          if value_delta <= @params[:green_limit]
            @evidence[:pefin_quantity_delta]['ignored'] = true
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
