module Risk
  module Pipeline
    module NewCNPJ
      class Serasa < Risk::Pipeline::Base
        #Interface Enforcement
        fetch_from Risk::Fetcher::Serasa
        run_referees Risk::Referee::NewCNPJ::PefinQuantity,
                     Risk::Referee::NewCNPJ::PefinValue,
                     Risk::Referee::NewCNPJ::RefinValue,
                     Risk::Referee::NewCNPJ::RefinQuantity,
                     Risk::Referee::NewCNPJ::ProtestValue,
                     Risk::Referee::NewCNPJ::ProtestQuantity,
                     Risk::Referee::NewCNPJ::LawsuitValue,
                     Risk::Referee::NewCNPJ::LawsuitQuantity,
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

        def decorate_evidences(key_indicator_report)
          Risk::Decorator::Serasa.new(key_indicator_report.evidences)
        end
      end
    end
  end
end
