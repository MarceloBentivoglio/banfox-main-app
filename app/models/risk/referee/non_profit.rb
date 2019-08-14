module Risk
  module Referee
    class NonProfit < Base
      def initialize(evidence)
        @evidence = {
          non_profit: evidence.non_profit
        }
        @description = ''
        @code = 'non_profit_organization'
        @title = 'Non Profit Organization'
        @params = {
          green: false,
        }
      end

      def assert
        if @evidence[:non_profit] == @params[:green]
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end
    end
  end
end
