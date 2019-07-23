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

        call_fetchers
        call_pipelines
      end

      def call_fetchers
        fetchers_required.each do |fetcher|
          Risk::Service::ExternalDatum.new(fetcher, @key_indicator_report).call unless fetcher.nil?
        end
      end

      def call_pipelines
        before_pipeline
        self.class.pipelines.each do |pipeline_class|
          pipeline_class.new(@key_indicator_report).call
        end
      end

      #called after fetchers have done their work 
      def before_pipeline
      end
    end
  end
end
