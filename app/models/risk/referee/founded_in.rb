module Risk
  module Referee
    class FoundedIn < Base
      def initialize(evidence)
        @evidence = {
          founded_in: evidence.founded_in
        }
        @code = 'founded_in'
        @title = 'Founded In'
        @description = @evidence[:founded_in]&.strftime
        @params = {
          green_limit: 3,
          yellow_limit: 2
        }
      end

      def assert
        if @evidence[:founded_in].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        else
          company_age = (Date.today - @evidence[:founded_in])/365

          if company_age >= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          elsif company_age  >= @params[:yellow_limit]
            Risk::KeyIndicatorReport::YELLOW_FLAG
          else
            Risk::KeyIndicatorReport::RED_FLAG
          end
        end
      end
    end
  end
end
