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

        #TODO change name to referees_list
        def run_referees(*referees)
          @referees = referees
        end
      end

      def valid_input_data?
        self.class.params.reduce(false)  do |valid, key|
          @key_indicator_report.input_data.has_key?(key.to_s)
        end
      end

      def identify_part
        sellers = Seller.where(cnpj: @key_indicator_report.cnpj)
        if sellers.any?
          return sellers.first
        end

        payers = Payer.where(cnpj: @key_indicator_report.cnpj)
        return payers.first if payers.any?

        nil
      end

      def require_fetcher?
        self.class.fetchers.any?
      end

      def call
        decorated_evidences = decorate_evidences(@key_indicator_report)
        if !self.class.referees.nil?
          self.class.referees.each do |referee_klass|
            decorated_evidences.each_cnpj do |cnpj, evidences|
              referee = referee_klass.new(evidences)
              if referee.multiple_assertions?
                key_indicators = referee.call
                key_indicators.each do |key_indicator|
                  @key_indicator_report.key_indicators[key_indicator[:code]] = key_indicator
                end
              else
                @key_indicator_report.key_indicators ||= {}
                @key_indicator_report.key_indicators[referee.code] = referee.call
              end
            end
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
