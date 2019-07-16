module Risk
  module Deserializer
    class Serasa
      def initialize(data)
        @data = data
      end

      def call
        {
          summary: summary
        }
      end

      def summary
        {
          pefin: {
            quantity: pefin&.first[:quantity],
            value: pefin&.first[:value],
            last_occurrence: Date.parse(pefin&.first[:date])
          },
          refin: {
            quantity: refin&.first[:quantity],
            value: refin&.first[:value],
            last_occurrence: Date.parse(refin&.first[:date])
          },


          serasa_searches: [],
        }
      end

      def pefin
        @data[:pefin]
      end

      def parse_pefin
      end

      def refin
        @data[:refin]
      end
    end
  end
end
