module Risk
  module Presenter
    class KeyIndicator
      def initialize(key_indicator)
        @key_indicator = key_indicator.with_indifferent_access
      end

      def title
        @key_indicator[:title]
      end

      def flag
        case @key_indicator[:flag]
        when -1
          'gray'
        when 0
          'green'
        when 1
          'yellow'
        when 2
          'red'
        end
      end

      def hex_color
        case @key_indicator[:flag]
        when -1
          'gray'
        when 0
          'green'
        when 1
          'yellow'
        when 2
          'red'
        end
      end
    end
  end
end
