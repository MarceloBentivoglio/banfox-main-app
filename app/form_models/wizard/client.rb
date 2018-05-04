module Wizard
  module Client
    STEPS = %w(step1 step2 step3 step4).freeze

    class Base
      include ActiveModel::Model
      attr_accessor :client

      delegate *::Client.attribute_names.map { |attr| [attr, "#{attr}="] }.flatten, to: :client

      def initialize(client_attributes)
        @client = ::Client.new(client_attributes)
      end
    end

    class Step1 < Base
      validates :company_name, presence: true
    end

    class Step2 < Step1
      validates :full_name, presence: true
    end

    class Step3 < Step2
      validates :cpf, presence: true
    end

    class Step4 < Step3
      validates :cnpj, presence: true
    end
  end
end
