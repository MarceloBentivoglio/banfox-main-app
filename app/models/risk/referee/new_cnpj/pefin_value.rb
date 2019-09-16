module Risk
  module Referee
    module NewCNPJ
      class PefinValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.pefin_value
          }

          @code = 'new_pefin_value_delta'
          @title = 'New Pefin Value Delta'
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
