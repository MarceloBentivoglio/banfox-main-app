module Risk
  module Referee
    class PartnerBankruptcyParticipation < Base
      def initialize(evidences)
        @collection_evidence = evidences.partner_data
        @code = 'partner_bankruptcy_participation'
        @title = 'Partner Bankruptcy Participation'
        @description = ''
        @params = {
          green: false
        }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            document: evidence.partner_document,
            name: evidence.partner_name,
            bankruptcy_participation: evidence.partner_bankruptcy_participation?
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
      end

      def assert
        if @evidence[:bankruptcy_participation] == @params[:green]
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::RED_FLAG
        end
      end

      def multiple_assertions?
        true
      end
    end
  end
end
