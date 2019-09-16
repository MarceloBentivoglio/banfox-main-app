module Risk
  module Referee
    module NewCNPJ
      class ProtestQuantity < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            quantity:  evidence.protest_quantity
          }

          @code = 'new_protest_quantity_delta'
          @title = 'New Protest Quantity Delta'
          @description = ''
          @params = { green_limit: 0 }
        end

        def assert
          if @evidence[:quantity] <= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
