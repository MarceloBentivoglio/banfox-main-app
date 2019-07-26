module Risk
  module Referee
    module DeltaEvaluator
      def evaluate_delta_for_negative_information(historic, current)
        if historic.nil?
          return Risk::KeyIndicatorReport::GRAY_FLAG
        else
          current ||= 0
          historic ||= 0

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
              Risk::KeyIndicatorReport::GREEN_FLAG
            elsif relative_delta <= @params[:yellow_limit]
              Risk::KeyIndicatorReport::YELLOW_FLAG
            else
              Risk::KeyIndicatorReport::RED_FLAG
            end
          end
        end
      end

    end
  end
end
