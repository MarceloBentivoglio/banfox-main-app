module Risk
  module Referee
    module NewCNPJ
      class PefinQuantity < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            quantity:  evidence.pefin_quantity
          }

          @code = 'new_pefin_quantity'
          @title = 'New Pefin Quantity'
          @description = ''
          @params = { green_limit: 0 }
        end

        def assert
          if @evidence[:quantity].to_i <= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end
    end
  end
end
