module Risk
  module Referee
    module NewCNPJ
      class LawsuitQuantity < ::Risk::Referee::Base
        def initialize(evidence)
          @evidence = {
            quantity:  evidence.lawsuit_quantity
          }

          @code = 'new_lawsuit_quantity_delta'
          @title = 'New Lawsuit Quantity Delta'
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
