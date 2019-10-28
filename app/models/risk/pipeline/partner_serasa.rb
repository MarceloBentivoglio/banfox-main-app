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
        begin
          last_operation = Operation.joins(:installments, invoices: [:payer, :seller])
                                    .where('installments.backoffice_status': ['approved' , 'deposited'])
                                    .where('invoices.seller': identify_part&.id)
                                    .last

        rescue Exception => e
          raise 'Recurrent Operation not found'
        end
        shortened_cnpj = @key_indicator_report.cnpj[0..7]

        historic = last_operation&.key_indicator_reports
                                 &.select {|kir| kir.cnpj == @key_indicator_report.cnpj }
                                 &.first
                                 &.evidences
                                 &.dig('serasa_api', shortened_cnpj)
                                 &.select {|evidence| !evidence.nil?}

        raise 'CNPJ has no historic' if historic.nil? || !historic.any?

        build_partner_historic(
          @key_indicator_report&.evidences&.dig('serasa_api', shortened_cnpj, 'partner_data'),
          historic
        )
        @key_indicator_report.key_indicators[shortened_cnpj] ||= {}
        @key_indicator_report.save

        @key_indicator_report.evidences
      end

      def build_partner_historic(current_partner_data, historic_data)
        return if current_partner_data.nil?
        historic = {}

        historic_data['partner_data'].each do |partner|
          historic[partner['cpf']] = partner
        end

        current_partner_data.each do |current_partner|
          if historic[current_partner['cpf']]
            current_partner['historic'] = historic[current_partner['cpf']]
          else
            current_partner['historic'] = {}
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
