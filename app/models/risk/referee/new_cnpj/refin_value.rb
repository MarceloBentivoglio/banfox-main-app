module Risk
  module Referee
    module NewCNPJ
      class RefinValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.refin_value
          }

          @code = 'new_refin_value_delta'
          @title = 'New Refin Value Delta'
          @description = ''
          @params = { green_limit: 0 }
        end

        def assert
          if @evidence[:value] <= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
