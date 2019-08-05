module Risk
  module Referee
    class SerasaInjuction < Base
      # entities must be a chronological ordered array
      def initialize(evidence)
        @evidence = {
          injuction:  evidence.injuction
        }
        @code = 'injuction'
        @title = 'Injuction'
        @description = 'Verifica se há liminar no Serasa'
        @params = {}
      end

      def call
        if @evidence[:injuction]
          Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          Risk::KeyIndicatorReport::GREEN_FLAG
        end
      end
    end
  end
end
