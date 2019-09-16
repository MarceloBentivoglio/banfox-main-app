module Risk
  module Referee
    module NewCNPJ
      class ProtestValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.protest_value
          }

          @code = 'new_protest_value_delta'
          @title = 'New Protest Value Delta'
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
