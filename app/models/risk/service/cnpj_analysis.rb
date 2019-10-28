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

        begin
          persist_analyzed_part
          call_fetchers #Fills evidences
          call_pipelines #Fills key_indicators
        rescue Exception => e
          Rollbar.error(e, "Error generating KRI: ##{@key_indicator_report.id}")
          @key_indicator_report.update(processed: true,
                                       with_error: true,
                                       processing_error_message: e.message)
        end
      end

      def persist_analyzed_part
        Risk::AnalyzedPart.create(
          key_indicator_report_id: @key_indicator_report.id,
          operation_id: @key_indicator_report.operation_id,
          cnpj: cnpj_root_format(@key_indicator_report.cnpj)
        )
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
