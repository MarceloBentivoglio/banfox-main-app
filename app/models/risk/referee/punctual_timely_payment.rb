module Risk
  module Referee
    class PunctualTimelyPayment < Base
      def initialize(evidence)
        @code = 'punctual_timely_payment'
        @title = 'Punctual Timely Payment'
        @description = ''
        @params = {
          green_limit: 80.0,
        }
        @evidence = evidence.punctual_timely_payment
      end

      def assert
        if @evidence.nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        elsif (@evidence[:percentage_start].to_f / 100) >= @params[:green_limit] 
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::YELLOW_FLAG
        end
      end
    end
  end
end
