module Risk
  module Pipeline
    class Serasa < Risk::Pipeline::Base
      fetch_from Risk::Fetcher::Serasa
      run_referees Risk::Referee::RefinValueDelta

      def build_evidences_with_historic
        cnpjs = @key_indicator_report.evidences.keys
        cnpjs.each do |cnpj|
          analyzed_parts = Risk::AnalyzedPart.where(cnpj: cnpj)
                                       .where.not(key_indicator_report_id: @key_indicator_report.id)
                                       .includes(:key_indicator_report)
                                       .order('created_at DESC')

          historic = analyzed_parts.map do |analyzed_part|
            analyzed_part.key_indicator_report.evidences[cnpj]
          end

          @key_indicator_report.evidences[cnpj][:historic] = historic
        end

        @key_indicator_report.evidences
      end
    end
  end
end
