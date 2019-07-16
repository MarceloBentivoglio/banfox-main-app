module Risk
  module Service
    class Report
      def self.call(input_data, pipeline)
        new(input_data, pipeline).call
      end

      def initialize(input_data, pipeline)
        @input_data = input_data
        @pipeline = pipeline
      end

      def call
        return false unless validate_input_data

        report = Risk::KeyIndicatorReport.create(input_data: @input_data)
        pipeline_strategy(@pipeline).call(@input_data, report)

        report
      end

      def validate_input_data
        cnpj = CNPJ.new(@input_data[:cnpj]).stripped

        return false if cnpj.blank? || !CNPJ.valid?(cnpj)

        true
      end

      def pipeline_strategy(pipeline)
        case pipeline
        when 'new_seller'
        end
      end
    end
  end
end
