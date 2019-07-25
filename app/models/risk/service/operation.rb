module Risk
  module Service
    class Operation
      class << self
        attr_reader :pipelines

        def pipeline_list(*pipelines)
          @pipelines = pipelines
        end
      end

      def fetchers_required
        self.class.pipelines.map {|pipeline| pipeline.fetchers }
                            .reduce([]) {|fetchers, fetcher| fetchers << fetcher }
                            .uniq
                            .flatten
      end

      def call(key_indicator_report)
        @key_indicator_report = key_indicator_report

        persist_analyzed_parts
        call_fetchers
        call_pipelines
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

      def persist_analyzed_parts
        AnalyzedPart.create(
          key_indicator_report_id: @key_indicator_report.id,
          cnpj: @key_indicator_report.operation.seller.cnpj
        )
        @key_indicator_report.operation.payers.each do |payer|
          AnalyzedPart.create(
            key_indicator_report_id: @key_indicator_report.id,
            cnpj: payer.cnpj
          )
        end
      end
    end
  end
end
