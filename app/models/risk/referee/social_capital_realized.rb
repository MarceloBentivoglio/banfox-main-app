module Risk
  module Referee
    class SocialCapitalRealized < Base

      def initialize(evidence)
        @evidence = {
          social_capital_realized: evidence.social_capital_realized
        }
        @code = 'social_capital_realized'
        @title = 'Social Capital Realized'
        @description = ''
        @params = { 
          green_limit: 50_000,
          yellow_limit: 10_000 
        }
      end

      def assert

        if @evidence[:social_capital_realized].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        elsif @evidence[:social_capital_realized] >= @params[:green_limit]
          Risk::KeyIndicatorReport::GREEN_FLAG
        elsif @evidence[:social_capital_realized] >= @params[:yellow_limit]
          Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end
    end
  end
end
