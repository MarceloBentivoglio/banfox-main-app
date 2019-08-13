module Risk
  module Service
    #Anti Corruption Layer
    class ExternalDatum

      def initialize(fetcher_class, key_indicator_report)
        @fetcher = fetcher_class.new(key_indicator_report)
        @key_indicator_report = key_indicator_report
        @query = key_indicator_report.input_data
        @ttl = key_indicator_report.ttl
      end

      def call
        #TTL = Time to live
        external_data = Risk::ExternalDatum.where(source: @fetcher.name)
                                           .where("query=?", JSON.generate(@query))
                                           .where('ttl >= ?', DateTime.now)
                                           .order('created_at DESC')
                                           .to_a

        if external_data.any? && external_data.first.ttl < DateTime.now || external_data.empty?
          @fetcher.call
          new_external_datum = Risk::ExternalDatum.create(source: @fetcher.name,
                                                          query: @query,
                                                          raw_data: @fetcher.data,
                                                          ttl: @ttl,
                                                         )

          external_data = [new_external_datum]
        end

        external_datum = external_data.last

        @key_indicator_report.external_data << external_datum
        @key_indicator_report.evidences[@fetcher.name] = if @fetcher.needs_parsing?
                                                           @fetcher.parser.call(external_datum)
                                                         else
                                                           external_datum.raw_data
                                                         end
        @key_indicator_report
      end
    end
  end
end
