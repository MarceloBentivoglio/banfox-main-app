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
          if evidence.partner_role == 'admin'
            nil
          else
            @evidence = {
              partner_role: evidence.partner_role
            }

            code = "#{@code}_#{evidence.partner_document}"

            {
              code: code,
              title: @title,
              description: evidence.partner_document,
              params: @params,
              evidence: @evidence,
              flag: assert
            }
          end
        end.select {|key_indicator| !key_indicator.nil? }
      end

      def assert
        if @evidence[:partner_role] == nil
          return Risk::KeyIndicatorReport::GRAY_FLAG
        elsif @evidence[:partner_role] == 'admin/associate'
          return Risk::KeyIndicatorReport::GREEN_FLAG
        elsif @evidence[:partner_role] == 'associate'
          return Risk::KeyIndicatorReport::YELLOW_FLAG
        else
          return Risk::KeyIndicatorReport::GRAY_FLAG
        end
      end

      def multiple_assertions?
        true
      end
    end
  end
end
