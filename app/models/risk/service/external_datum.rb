module Risk
  module Service
    class ExternalDatum

      def initialize(fetcher, key_indicator_report)
        @fetcher = fetcher
        @key_indicator_report = key_indicator_report
        @query = key_indicator_report.input_data
        @ttl = key_indicator_report.ttl
      end

      def call
        external_data = Risk::ExternalDatum.where(source: @fetcher.name)
                                           .where(query: @query)
                                           .where('ttl >= ?', DateTime.now)
                                           .order('created_at DESC')
                                           .to_a

        if external_data.any? && external_data.first.ttl < DateTime.now || external_data.empty?
          new_external_data = @fetcher.call
          new_external_datum = Risk::ExternalDatum.create(source: @fetcher.name,
                                                          query: @query,
                                                          raw_data: new_external_data,
                                                          ttl: @ttl,
                                                         )

          external_data = [new_external_datum]
        end

        external_datum = external_data.last

        @key_indicator_report.external_data << external_datum
        @key_indicator_report.evidences[@fetcher.name] = if fetcher.needs_parsing?
                                                           fetcher.parser.call(external_datum)
                                                         else
                                                           external_datum.raw_data
                                                         end

        external_data.last
      end

      def fetcher
        @fetcher_instance ||= @fetcher.new(@key_indicator_report)
      end
    end
  end
end
