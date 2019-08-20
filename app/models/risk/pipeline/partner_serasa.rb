module Risk
  module Pipeline
    class PartnerSerasa < Base
      fetch_from Risk::Fetcher::Serasa
      run_referees Risk::Referee::PartnerRefinQuantityDelta,
                   Risk::Referee::PartnerRefinValueDelta,
                   Risk::Referee::PartnerLawsuitQuantityDelta,
                   Risk::Referee::PartnerLawsuitValueDelta,
                   Risk::Referee::PartnerPefinQuantityDelta,
                   Risk::Referee::PartnerPefinValueDelta,
                   Risk::Referee::PartnerProtestQuantityDelta,
                   Risk::Referee::PartnerProtestValueDelta,
                   Risk::Referee::PartnerBankruptcyParticipation,
                   Risk::Referee::AdminRefinQuantityDelta,
                   Risk::Referee::AdminRefinValueDelta,
                   Risk::Referee::AdminLawsuitQuantityDelta,
                   Risk::Referee::AdminLawsuitValueDelta,
                   Risk::Referee::AdminPefinQuantityDelta,
                   Risk::Referee::AdminPefinValueDelta,
                   Risk::Referee::AdminProtestQuantityDelta,
                   Risk::Referee::AdminProtestValueDelta,
                   Risk::Referee::AdminBankruptcyParticipation

      def build_evidences
        cnpjs = @key_indicator_report.evidences['serasa_api'].keys
        cnpjs.each do |cnpj|
          analyzed_parts = Risk::AnalyzedPart.where(cnpj: cnpj)
            .where.not(key_indicator_report_id: @key_indicator_report.id)
            .includes(:key_indicator_report)
            .order('created_at DESC')

          historic = analyzed_parts.map do |analyzed_part|
            analyzed_part.key_indicator_report.evidences['serasa_api'][cnpj]
          end

          build_partner_historic(
            @key_indicator_report.evidences['serasa_api'][cnpj]['partner_data'],
            historic
          )
          @key_indicator_report.key_indicators[cnpj] ||= {}
          @key_indicator_report.save
        end

        @key_indicator_report.evidences
      end

      def build_partner_historic(current_partner_data, historic_data)
        historic = {}

        historic_data.each do |company|
          company['partner_data'].each do |partner|
            historic[partner['cpf']] ||= []
            historic[partner['cpf']] << partner
          end
        end

        current_partner_data.each do |current_partner|
          if historic[current_partner['cpf']]
            current_partner['historic'] = historic[current_partner['cpf']]
          else
            current_partner['historic'] = []
          end
        end

        current_partner_data
      end

      def call
        build_evidences

        super
      end

      def decorate_evidences(key_indicator_report)
        Risk::Decorator::PartnerSerasa.new(key_indicator_report.evidences)
      end
    end
  end
end
