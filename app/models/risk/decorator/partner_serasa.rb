module Risk
  module Decorator
    class PartnerSerasa
      def initialize(evidences)
        @evidences = evidences
      end

      def partner_data
        @evidences.with_indifferent_access['partner_data'].map do |partner_data|
          Risk::Decorator::Serasa.new(partner_data)
        end
      end

      def each_cnpj
        @evidences['serasa_api'].keys.each do |cnpj|
          yield cnpj, self.class.new(@evidences['serasa_api'][cnpj]) if cnpj != 'historic'
        end
      end
    end
  end
end
