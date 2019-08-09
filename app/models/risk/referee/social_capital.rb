module Risk
  module Referee
    class SocialCapital < Base

      def initialize(evidence)
        @evidence = {
          social_capital: evidence.social_capital
        }
        @code = 'social_capital'
        @title = 'Social Capital'
        @description = ''
        @params = {
          green_limit: 50_000,
          yellow_limit: 10_000
        }
      end

      def assert
        if @evidence[:social_capital].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        elsif @evidence[:social_capital] >= @params[:green_limit]
          Risk::KeyIndicatorReport::GREEN_FLAG
        elsif @evidence[:social_capital] >= @params[:yellow_limit]
          Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end
    end
  end
end
