module Risk
  module Referee
    module NewCNPJ
      class PefinValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.pefin_value
          }

          @code = 'new_pefin_value'
          @title = 'New Pefin Value'
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
