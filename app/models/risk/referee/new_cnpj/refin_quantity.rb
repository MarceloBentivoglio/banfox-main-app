module Risk
  module Referee
    module NewCNPJ
      class RefinQuantity < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            quantity:  evidence.refin_quantity
          }

          @code = 'new_refin_quantity'
          @title = 'New Refin Quantity'
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
