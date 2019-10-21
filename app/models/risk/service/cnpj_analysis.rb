module Risk
  module Service
    class CNPJAnalysis
      include CNPJFormatter
      class << self
        attr_reader :pipelines
        def pipeline_list(*pipelines)
          @pipelines = pipelines
        end
      end

      def call(key_indicator_report)
        @key_indicator_report = key_indicator_report

        persist_analyzed_parts
        call_fetchers #Fills evidences
        call_pipelines #Fills key_indicators
      end

      def persist_analyzed_parts
        @key_indicator_report.input_data.each do |cnpj|
          Risk::AnalyzedPart.create(
            key_indicator_report_id: @key_indicator_report.id,
            operation_id: @key_indicator_report.operation_id,
            cnpj: cnpj_root_format(cnpj)
          )
        end
      end

      def fetchers_required
        self.class.pipelines
                  .reject {|pipeline| pipeline.fetchers.nil?}
                  .map {|pipeline| pipeline.fetchers }
                  .reduce([]) {|fetchers, fetcher| fetchers << fetcher }
                  .uniq
                  .flatten
      end

      def call_fetchers
        fetchers_required.each do |fetcher|
          Risk::Service::ExternalDatum.new(fetcher, @key_indicator_report).call unless fetcher.nil?
        end
      end

      def call_pipelines
        self.class.pipelines.each do |pipeline_class|
          pipeline_class.new(@key_indicator_report).call
        end
      end
    end
  end
end
