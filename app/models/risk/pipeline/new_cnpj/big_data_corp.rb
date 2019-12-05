module Risk
  module Pipeline
    module NewCNPJ
      class BigDataCorp < Risk::Pipeline::Base
        fetch_from Risk::Fetcher::BigDataCorp

        def decorate_evidences(key_indicator_report)
          key_indicator_report.evidences
        end
      end
    end
  end
end
