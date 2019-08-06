module Risk
  module Referee
    module DeltaEvaluator
      def evaluate_delta_for_negative_information(historic, current)
        if historic.nil?
          return Risk::KeyIndicatorReport::GRAY_FLAG
        else
          current ||= 0
          historic ||= 0

          absolute_delta = (current.to_i - historic.to_i).to_f
          if historic.to_f.zero?
            if absolute_delta.zero?
              return Risk::KeyIndicatorReport::GREEN_FLAG
            else
              return Risk::KeyIndicatorReport::YELLOW_FLAG
            end
          else
            relative_delta = absolute_delta / historic.to_i
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
