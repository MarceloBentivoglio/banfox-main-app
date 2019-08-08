module Risk
  module Referee
    class PartnerLinkAdmin < Base
      def initialize(evidence)
        @collection_evidence = evidence.partner_data
        @code = 'partner_link_admin'
        @title = "Partner Link Admin"
        @params = {}
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            partner_role: evidence.partner_role
          }

          code = "#{@code}_#{evidence.partner_cpf}"

          {
            code: code,
            title: @title,
            description: evidence.partner_cpf,
            params: @params,
            evidence: @evidence,
            flag: assert
          }
        end
      end

      def assert
        if @evidence[:partner_role] == nil
          return Risk::KeyIndicatorReport::GRAY_FLAG
        elsif ['admin', 'admin/associate'].include? @evidence[:partner_role]
          return Risk::KeyIndicatorReport::GREEN_FLAG
        else
          return Risk::KeyIndicatorReport::YELLOW_FLAG
        end
      end
    end
  end
end
