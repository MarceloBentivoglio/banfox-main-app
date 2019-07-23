module Risk
  module Referee
    module DeltaEvaluator

      def evaluate_delta_for_negative_information(historic, current)
        if @entities.size < 2
          return Risk::KeyIndicatorReport::GRAY_FLAG
        else
          absolute_delta = (current - historic).to_f
          if historic == 0
            if absolute_delta == 0
              return Risk::KeyIndicatorReport::GREEN_FLAG
            else
              return Risk::KeyIndicatorReport::YELLOW_FLAG
            end
          else
            relative_delta = absolute_delta / historic
            if relative_delta <= @params[:green_limit]
              return Risk::KeyIndicatorReport::GREEN_FLAG
            elsif relative_delta <= @params[:yellow_limit]
              return Risk::KeyIndicatorReport::YELLOW_FLAG
            else
              return Risk::KeyIndicatorReport::RED_FLAG
            end
          end
        end
      end

    end
  end
end
