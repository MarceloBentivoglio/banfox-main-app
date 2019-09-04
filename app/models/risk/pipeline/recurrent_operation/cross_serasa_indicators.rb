module Risk
  module Pipeline
    module RecurrentOperation
      class CrossSerasaIndicators < Base
        run_referees Risk::Referee::CrossPefinValue,
                     Risk::Referee::CrossPefinQuantity,
                     Risk::Referee::CrossRefinValue,
                     Risk::Referee::CrossRefinQuantity

        def decorate_evidences(key_indicator_report)
          Risk::Decorator::KeyIndicatorReport.new(key_indicator_report)
        end
      end
    end
  end
end
