module Risk
  module Pipeline
    class Serasa < Risk::Pipeline::Base
      #Interface Enforcement
      fetch_from Risk::Fetcher::Serasa
      run_referees Risk::Referee::RefinValueDelta,
                   Risk::Referee::RefinQuantityDelta,
                   Risk::Referee::LawsuitQuantityDelta,
                   Risk::Referee::LawsuitValueDelta,
                   Risk::Referee::PefinValueDelta,
                   Risk::Referee::PefinQuantityDelta,
                   Risk::Referee::ProtestValueDelta,
                   Risk::Referee::ProtestQuantityDelta,
                   Risk::Referee::SerasaInjuction,
                   Risk::Referee::FoundedIn

      def call
        build_evidences_with_historic
        super
      end

      def decorate_evidences(evidences)
        Risk::Decorator::Serasa.new(evidences)
      end

      def build_evidences_with_historic
        cnpjs = @key_indicator_report.evidences['serasa_api'].keys
        cnpjs.each do |cnpj|
          analyzed_parts = Risk::AnalyzedPart.where(cnpj: cnpj)
                                             .where.not(key_indicator_report_id: @key_indicator_report.id)
                                             .includes(:key_indicator_report)
                                             .order('created_at DESC')

          historic = analyzed_parts.map do |analyzed_part|
            analyzed_part.key_indicator_report.evidences['serasa_api'][cnpj]
          end

          @key_indicator_report.evidences['serasa_api'][cnpj]['historic'] = historic
          @key_indicator_report.key_indicators[cnpj] ||= {}
          @key_indicator_report.save
        end

        @key_indicator_report.evidences
      end
    end
  end
end
