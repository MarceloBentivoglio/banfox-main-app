module Risk
  module Referee
    module NewCNPJ
      class LawsuitValue < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            value:  evidence.lawsuit_value
          }

          @code = 'new_lawsuit_value'
          @title = 'New Lawsuit Value'
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
