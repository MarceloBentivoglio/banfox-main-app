module Risk
  module Referee
    module NewCNPJ
      class PefinQuantity < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            quantity:  evidence.pefin_quantity
          }

          @code = 'new_pefin_quantity_delta'
          @title = 'New Pefin Quantity Delta'
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
