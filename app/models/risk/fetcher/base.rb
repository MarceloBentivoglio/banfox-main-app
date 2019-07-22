module Risk
  module Fetcher
    class Base
      attr_reader :key_indicator_report, :data

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
        @data = []
      end

      def call
        http_call(payload)
      end

      def http_call(_payload, _target, _headers)

        _payload ||= payload
        _target  ||= target
        _headers ||= headers

        data << RestClient::Request.execute(method: http_method,
                                    url: _target,
                                    payload: _payload,
                                    headers: _headers
                                   )
      end
      
      def name
        raise 'Must implement name'
      end

      def needs_parsing?
        raise 'Must implement needs_parsing?'
      end

      def http_method
        raise 'Must implement http_method'
      end

      def target
        raise 'Must implement target'
      end

      def headers
        raise 'Must implement headers'
      end

      def payload
        raise 'Must implement payload'
      end
    end
  end
end
