module Risk
  module Referee
    module NewCNPJ
      class ProtestValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.protest_value
          }

          @code = 'new_protest_value'
          @title = 'New Protest Value'
          @description = ''
          @params = { green_limit: 0 }
        end

        def assert
          if @evidence[:value].to_i <= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
