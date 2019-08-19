module Risk
  module Referee
    class Bankruptcy < Base
      def initialize(evidence)
        @evidence = {
          bankruptcy: evidence.bankruptcy?
        }
        @code = 'bankruptcy'
        @title = 'Bankruptcy'
        @params = {
          green: false
        }
      end

      def assert
        if @evidence[:bankruptcy] == @params[:green]
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end
    end
  end
end
