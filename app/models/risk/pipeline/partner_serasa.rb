module Risk
  module Pipeline
    class PartnerSerasa < Base
      fetch_from Risk::Fetcher::Serasa
      run_referees Risk::Referee::PartnerRefinQuantityDelta,
                   Risk::Referee::PartnerRefinValueDelta,
                   Risk::Referee::PartnerLawsuitQuantityDelta,
                   Risk::Referee::PartnerLawsuitValueDelta,
                   Risk::Referee::PartnerPefinQuantityDelta,
                   Risk::Referee::PartnerPefinValueDelta

      def build_evidences
        cnpjs = @key_indicator_report.evidences['serasa_api'].keys
        cnpjs.each do |cnpj|
          analyzed_parts = Risk::AnalyzedPart.where(cnpj: cnpj)
            .where.not(key_indicator_report_id: @key_indicator_report.id)
            .includes(:key_indicator_report)
            .order('created_at DESC')

          historic = analyzed_parts.first.key_indicator_report.evidences['serasa_api'][cnpj]
          build_partner_historic(
            @key_indicator_report.evidences['serasa_api'][cnpj]['partner_data'],
            historic
          )
          @key_indicator_report.key_indicators[cnpj] = {}
          @key_indicator_report.save
        end

        @key_indicator_report.evidences
      end

      def build_partner_historic(current_partner_data, historic_data)
        historic = {
        }

        historic_data['partner_data'].each do |historic_partner_data|
          historic[historic_partner_data['cpf']] = historic_partner_data
        end

        current_partner_data.each do |partner_data|
          partner_data['historic'] = [ 
            historic[partner_data['cpf']]
          ]
        end

        current_partner_data
      end

      def call
        build_evidences

        super
      end

      def decorate_evidences(evidences)
        Risk::Decorator::PartnerSerasa.new(evidences)
      end
    end
  end
end
