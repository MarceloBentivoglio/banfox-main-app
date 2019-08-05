module Risk
  module Pipeline
    class Base
      attr_accessor :key_indicator_report, :evidences

      def initialize(key_indicator_report)
        @key_indicator_report = key_indicator_report
      end

      class << self
        attr_reader :params, :fetchers, :referees

        def required_params(*params)
          @params = params
        end

        def fetch_from(*fetchers)
          @fetchers = fetchers
        end

        def run_referees(*referees)
          @referees = referees
        end
      end

      def valid_input_data?
        self.class.params.reduce(false)  do |valid, key|
          @key_indicator_report.input_data.has_key?(key.to_s)
        end
      end

      def require_fetcher?
        self.class.fetchers.any?
      end

      def call
        self.class.referees.each do |referee_klass|
          decorated_evidences = decorate_evidences(@key_indicator_report.evidences)

          decorated_evidences.each_cnpj do |cnpj, decorated_evidence|
            referee = referee_klass.new(decorated_evidence)
            @key_indicator_report.key_indicators[cnpj][referee.code] = {
              title: referee.title,
              description: referee.description,
              params: referee.params,
              evidence: referee.evidence,
              flag: referee.call,
            }
          end
        end

        @key_indicator_report.save
      end

      def decorate_evidences(evidences)
        raise 'Must implement decorate_evidences'
      end
    end
  end
end
