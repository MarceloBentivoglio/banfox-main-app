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
                   Risk::Referee::PartnerEntryDate,
                   Risk::Referee::FoundedIn,
                   Risk::Referee::SocialCapital,
                   Risk::Referee::SocialCapitalRealized,
                   Risk::Referee::CompanyStatus,
                   Risk::Referee::SerasaQueries,
                   Risk::Referee::Bankruptcy,
                   Risk::Referee::PefinLastOccurrence,
                   Risk::Referee::RefinLastOccurrence

      def call
        build_evidences_with_historic
        super
      end

      def decorate_evidences(key_indicator_report)
        Risk::Decorator::Serasa.new(key_indicator_report.evidences)
      end

      def build_evidences_with_historic
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

        @key_indicator_report.evidences['serasa_api'][shortened_cnpj]['historic'] = historic
        @key_indicator_report.key_indicators[cnpj] ||= {}
        @key_indicator_report.save

        @key_indicator_report.evidences
      end
    end
  end
end
