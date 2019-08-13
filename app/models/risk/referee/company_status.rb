module Risk
  module Referee
    class CompanyStatus < Base
      def initialize(evidence)
        @evidence = {
          status: evidence.company_status
        }
        @code = 'company_status'
        @title = 'Company Status'
        @params = {
          green: 'ATIVA'
        }
      end

      def assert
        return Risk::KeyIndicatorReport::GRAY_FLAG if @evidence[:status].nil?

        if @evidence[:status] == @params[:green]
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end
    end
  end
end
