module Risk
  module Referee
    module DeltaEvaluator
      def delta(historic, current)
        if historic.to_i.zero?
          absolute_delta(historic, current)
        else
          absolute_delta(historic, current) / historic.to_i
        end
      end

      def absolute_delta(historic, current)
        (current.to_i - historic.to_i).to_f
      end

      def evaluate_delta_for_negative_information(historic, current)
        if historic.nil?
          return Risk::KeyIndicatorReport::GRAY_FLAG
        else
          current ||= 0
          historic ||= 0

          delta = absolute_delta(historic, current)
          if historic.to_f.zero?
            if delta.zero?
              return Risk::KeyIndicatorReport::GREEN_FLAG
            else
              return Risk::KeyIndicatorReport::YELLOW_FLAG
            end
          else
            delta = delta / historic.to_i
            if delta <= @params[:green_limit]
              Risk::KeyIndicatorReport::GREEN_FLAG
            elsif delta <= @params[:yellow_limit]
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
