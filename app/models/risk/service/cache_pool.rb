module Risk
  module Service
    class CachePool
      attr_reader :cache_key

      def self.call(service_class, service_params, ttl = 60)
        new(service_class, service_params, ttl).call
      end

      def initialize(service_class, service_params, ttl = 60)
        @service_class = service_class
        @service_params = service_params
        @ttl = ttl
      end

      def cache_engine
         @cache_engine ||= Redis.new
      end

      def call
        @cache_key = self.class.generate_cache_key(@service_class, @service_params)
        response = cache_engine.get(@cache_key)
        if response.nil?
          response = @service_class.call(@service_params)
          cache_engine.set(@cache_key, response)
        end

        { :"#{@cache_key}" => response }
      end

      def self.generate_cache_key(service_class, service_params)
        key_string   = service_params.keys.reduce('') { |r, v| r + v.to_s }
        value_string = service_params.values.reduce('') { |r, v| r + v.to_s }

        "#{service_class.name.parameterize}_#{key_string}_#{value_string}"
      end
    end
  end
end
