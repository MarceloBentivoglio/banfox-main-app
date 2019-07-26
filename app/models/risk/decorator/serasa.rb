module Risk
  module Decorator
    class Serasa
      attr_accessor :evidences

      def initialize(evidences = {})
        @evidences = evidences.with_indifferent_access
      end

      def refin_value
        @evidences.dig(:refin)&.last&.dig(:value) || 0
      end

      def refin_historic_value
        if @evidences.dig(:historic)&.any?
          @evidences.dig(:historic)&.last&.dig(:refin)&.last&.dig(:value) || 0
        else
          nil
        end
      end

      def refin_quantity
        @evidences&.dig(:refin).last&.dig(:quantity)
      end

      def refin_historic_quantity
        if @evidences.dig(:historic).any?
          @evidences.dig(:historic)&.last&.dig(:refin)&.last&.dig(:quantity) || 0
        else
          nil
        end
      end

      def each_cnpj
        @evidences['serasa_api'].keys.each do |cnpj|
          yield cnpj, self.class.new(@evidences['serasa_api'][cnpj]) if cnpj != 'historic'
        end
      end
    end
  end
end
