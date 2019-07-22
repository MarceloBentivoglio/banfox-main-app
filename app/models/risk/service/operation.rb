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
        fetchers_required.each do |fetcher|
          Risk::Service::ExternalDatum.new(fetcher, key_indicator_report).call unless fetcher.nil?
        end
      end
    end
  end
end
