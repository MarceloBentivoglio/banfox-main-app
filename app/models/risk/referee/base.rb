module Risk
  module Referee
    class Base
      attr_reader :target, :code, :evidence, :title, :description, :params

      def initialize(evidences)
        @evidences = evidences
      end

      def build_key_indicator(evidence)
        {
          title: self.title,
          description: self.description,
          params: self.params,
          evidence: self.evidence,
          flag: self.assert,
        }
      end

      def call
        build_key_indicator(evidence)
      end

      def multiple_assertions?
        false
      end
    end
  end
end
