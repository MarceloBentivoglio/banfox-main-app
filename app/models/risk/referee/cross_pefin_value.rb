module Risk
  module Referee
    class CrossPefinValue < Base
      include DeltaEvaluator

      def initialize(evidence)
        @root_evidence = evidence.with_indifferent_access
        @evidence = {
          pefin_value_delta: @root_evidence[:pefin_value_delta],
          pefin_quantity_delta: @root_evidence[:pefin_quantity_delta]
        }.with_indifferent_access

        @code = 'cross_pefin_value'
        @title = 'Cross Pefin Value'
        @description = ''
        @params = {
          green_limit: 0.1
        }
      end

      def assert
        return Risk::KeyIndicatorReport::GRAY_FLAG if @evidence[:pefin_value_delta].nil? || @evidence[:pefin_quantity_delta].nil?

        if @evidence[:pefin_value_delta]['flag'] == Risk::KeyIndicatorReport::RED_FLAG
          return Risk::KeyIndicatorReport::YELLOW_FLAG 
        elsif @evidence[:pefin_value_delta]['flag'] == Risk::KeyIndicatorReport::GREEN_FLAG
          return Risk::KeyIndicatorReport::GREEN_FLAG
        else
          quantity_delta = delta(
            @evidence.dig(:pefin_quantity_delta, :evidence, :historic_quantity),
            @evidence.dig(:pefin_quantity_delta, :evidence, :current_quantity)
          )

          if quantity_delta <= @params[:green_limit]
            @evidence[:pefin_value_delta]['ignored'] = true
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
