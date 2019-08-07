module Risk
  module Referee
    class PartnerEntryDate < Base
      def initialize(evidence)
        @collection_evidence = evidence.partner_documents
        @code = 'partner_entry_date'
        @title = 'Partner Entry Date'
        @params = {
          green_limit: 2,
        }
      end

      def call
        @collection_evidence.map do |evidence|
          @evidence = {
            name: evidence.partner_name,
            pf_or_pj: evidence.partner_pf_or_pj,
            cpf_or_cnpj: evidence.partner_cpf_or_cnpj,
            entry_date: evidence.partner_entry_date
          }

          code = "#{@code}_#{evidence.partner_cpf_or_cnpj}"

          {
            code: code,
            title: @title,
            description: evidence&.partner_entry_date&.strftime,
            evidence: @evidence,
            params: @params,
            flag: assert
          }
        end
      end

      def assert
        if @evidence[:entry_date].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        else
          year_diff = (Date.today - @evidence[:entry_date])/365
         
          if year_diff >= @params[:green_limit]
            Risk::KeyIndicatorReport::GREEN_FLAG
          else
            Risk::KeyIndicatorReport::YELLOW_FLAG
          end
        end
      end

      def multiple_assertions?
        true
      end
    end
  end
end
