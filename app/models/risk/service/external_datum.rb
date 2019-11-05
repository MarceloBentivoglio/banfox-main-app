module Risk
  module Service
    class ExternalDatum

      def initialize(fetcher_class, key_indicator_report)
        @fetcher = fetcher_class.new(key_indicator_report)
        @key_indicator_report = key_indicator_report
        @query = JSON.generate({ cnpj: CNPJ.new(key_indicator_report.cnpj).stripped })
        @ttl = key_indicator_report.ttl
      end

      def cached_data
        @cached_data ||= Risk::ExternalDatum.where(source: @fetcher.name)
                                            .where("query=?", @query)
                                            .where('ttl >= ?', DateTime.now)
                                            .order('created_at DESC')
                                            .to_a
      end

      def call
        if cached_data.any? && cached_data.first.ttl < DateTime.now || cached_data.empty?
          @fetcher.call
          external_datum = Risk::ExternalDatum.create(source: @fetcher.name,
                                                          query: @query,
                                                          raw_data: @fetcher.data,
                                                          ttl: @ttl,
                                                         )

        else
          external_datum = cached_data.last
        end

        @key_indicator_report.external_data << external_datum
        @key_indicator_report.evidences[@fetcher.name] = if @fetcher.needs_parsing?
                                                           @fetcher.parser.call(external_datum)
                                                         else
                                                           external_datum.raw_data
                                                         end

        @key_indicator_report.save
        @key_indicator_report
      end
    end
  end
end
