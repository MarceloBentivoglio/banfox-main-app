module Risk
  module Decorator
    class Serasa
      attr_accessor :data

      def initialize(data = {})
        @data = data
      end

      def refin_value
        @data.dig(:refin, :value) || 0
      end

      def refin_historic_value
        if @data.dig(:historic).any?
          @data.dig(:historic)&.last&.dig(:refin, :value) || 0
        else
          nil
        end
      end

      def refin_quantity
        @data.dig(:refin, :quantity)
      end

      def refin_historic_quantity
        if @data.dig(:historic).any?
          @data.dig(:historic)&.last&.dig(:refin, :quantity) || 0
        else
          nil
        end
      end
    end
  end
end
