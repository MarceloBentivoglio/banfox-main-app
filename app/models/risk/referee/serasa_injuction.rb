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
        @description = 'Verify if there is a injuction at Serasa'
        @params = {}
      end

      def call
        {
          code: @code,
          title: @title,
          description: evidence.partner_cpf,
          params: @params,
          evidence: @evidence,
          flag: assert
        }
      end

      def assert
        if @evidence[:injuction]
          Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          Risk::KeyIndicatorReport::GREEN_FLAG
        end
      end
    end
  end
end
