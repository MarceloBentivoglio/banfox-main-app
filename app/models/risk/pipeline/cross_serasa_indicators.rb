module Risk
  module Pipeline
    class CrossSerasaIndicators < Base
      run_referees Risk::Referee::CrossPefinValue,
                   Risk::Referee::CrossPefinQuantity

      def decorate_evidences(key_indicator_report)
        Risk::Decorator::KeyIndicatorReport.new(key_indicator_report)
      end
    end
  end
end