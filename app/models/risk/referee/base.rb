module Risk
  module Referee
    class Base
      attr_reader :target, :code, :evidence, :title, :description, :params

      def initialize(evidences)
        @evidences = evidences
      end

      def build_key_indicator(evidence)
        {
          code: self.code,
          title: self.title,
          description: self.description,
          evidence: self.evidence,
          params: self.params,
          flag: self.assert,
        }
      end

      def call
        build_key_indicator(evidence)
      end

      def multiple_assertions?
        false
      end

      def repr_date(date_object)
        month = date_object&.month&.to_s&.rjust(2, '0')
        day   = date_object&.day&.to_s&.rjust(2, '0')

        "#{day}/#{month}/#{date_object&.year}"
      end

    end
  end
end
