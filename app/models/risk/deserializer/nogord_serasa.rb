module Risk
  module Deserializer
    class NogordSerasa
      def initialize(data)
        @data = data
      end

      def call
        {
          summary: Risk::Entity::Serasa::CompanySummary.new(Risk::Deserializer::SerasaSummary.new(@data).call),
          corporate_control: Risk::Entity::Serasa::CorporateControl.new(corporate_control(@data)),
        }
      end

      def corporate_control(data)
        {
          share_capital: data['controle_societario_capital_social']["valor_capital_social"],
          realized_capital: data['controle_societario_capital_social']['valor_capital_realizado']
        }
      end

      def admin_group(data)
        data.map do |admin_data|
          {
            fullname: admin_data['nome_administrador'],
            cpf: admin_data['cnpj_cpf_socio'],
            nationality: admin_data['nacionalidade'],
            civil_state: admin_data['estado_civil'],
            role: admin_data['cargo'],
            sign_in_at: Date.parse(admin_data['data_inicio_mandato']),
          }
        end
      end
    end
  end
end
