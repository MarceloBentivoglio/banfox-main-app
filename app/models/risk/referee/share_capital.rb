module Risk
  module Referee
    class ShareCapital < Base
      def initialize(evidence)
        @evidence = evidence
        @code = ''
        @title = ''
        @description = ''
        @params = {
          red_limit: 10_000,
          yellow_limit: 50_000
        }
      end

      def call
        share_capital = @evidence.share_capital
        if share_capital < @params[:red_limit]
          Risk::KeyIndicatorReport::RED_FLAG
        elsif share_capital >= @params[:red_limit] && share_capital < @params[:yellow_limit]
          Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          Risk::KeyIndicatorReport::GREEN_FLAG
        end
      end
    end
  end
end
