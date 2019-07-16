module Risk
  module Deserializer
    class SerasaSummary
      attr_reader :nogord_data

      def initialize(nogord_data)
        @nogord_data = nogord_data
      end

      def call
        {
          serasa_searches: serasa_searches,
          pefin: pefin,
          refin: refin,
          protest: protest,
          lawsuit: lawsuit,
          check_ccf: check_ccf(nogord_data["informacoes_recheque_cheque_sem_fundo_ccf"])
        }.with_indifferent_access
      end

      def check_ccf(data)
        begin
          first_check_ccf = data.first

          last_check_ccf = data.inject(first_check_ccf) do |current_check, check_data|
            current_check_date = Date.parse(current_check['data'])
            check_date = Date.parse(check_data['data'])
            return check_data if check_date > current_check_date

            current_check
          end

          data = {
            quantity: last_check_ccf['quantidade_ocorrencias'],
            value: 0,
            last_occurrence: Date.parse(last_check_ccf['data'])
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa check_ccf')
        else
          return data
        end

        nil
      end


      def lawsuit
        begin
          data = {
            quantity: count_lawsuit(nogord_data['informacoes_concentre_acoes_judiciais']),
            value: lawsuit_value(nogord_data['informacoes_concentre_acoes_judiciais']),
            last_occurrence: lawsuit_last_occurrence(nogord_data['informacoes_concentre_acoes_judiciais']),
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa lawsuit')
        else
          return data
        end

        nil
      end

      def protest
        begin
          data = {
            quantity: count_protest(nogord_data['informacoes_concentre_protestos']),
            value: protest_value(nogord_data['informacoes_concentre_protestos']),
            last_occurrence: protest_last_occurrence(nogord_data['informacoes_concentre_protestos'])
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa protest')
        else
          return data
        end

        nil
      end

      def refin
        begin
          data = {
            quantity: count_refin(nogord_data['pendencias_financeiras_refin']),
            value: refin_value(nogord_data['pendencias_financeiras_refin']),
            last_occurrence: refin_last_occurrence(nogord_data['pendencias_financeiras_refin'])
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa refin')
        else
          return data
        end

        nil
      end

      def pefin
        begin
          data = {
            quantity: count_pefin(nogord_data['pendencias_financeiras_pefin']),
            value: pefin_value(nogord_data['pendencias_financeiras_pefin']),
            last_occurrence: pefin_last_occurrence(nogord_data['pendencias_financeiras_pefin'])
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa pefin')
        else
          return data
        end

        nil
      end

      def serasa_searches
        begin
          data = {
            quantity: count_serasa_searches(nogord_data['consultas_serasa']),
            last_occurrence: last_serasa_search_date(nogord_data['consultas_serasa']),
          }
        rescue Exception => e
          Rollbar.error(e, 'Error trying to deserialize Nogord/Serasa serasa_searches')
        else
          return data
        end

        nil
      end

      def count_serasa_searches(data)
        data&.reduce(0) do |total, n| 
          total + n['quantidade_consulta_por_empresa'] + n['quantidade_consulta_por_financeira']
        end
      end

      def count_company_searches(data)
        data&.reduce(0) do |total, n|
          total + n['quantidade_consulta_por_empresa']
        end
      end

      def count_financial_company_searches(data)
        data&.reduce(0) do |total, n|
          total + n['quantidade_consulta_por_financeira']
        end
      end

      def count_pefin(data)
        last_pefin(data)['quantidade_pendencias_financeiras']
      end

      def pefin_value(data)
        last_pefin(data)['valor']
      end

      def pefin_last_occurrence(data)
        Date.parse(last_pefin(data)['data_ocorrencia'])
      end

      def count_refin(data)
        last_refin(data)['quantidade_refinanciamento']
      end

      def refin_value(data)
        last_refin(data)['valor']
      end

      def refin_last_occurrence(data)
        last_occurrence = last_refin(data)['data_ocorrencia']
        Date.parse(last_occurrence)
      end

      def last_protest(data)
        return nil unless data.any?
        first_date = Date.parse(data.first['data_protesto'])
        @last_protest ||= data.inject(first_date) do |fd, refin|
          occurrence = Date.parse(refin['data_protesto'])
          return refin if occurrence > first_date

          data.first
        end
      end

      def count_protest(data)
        last_protest(data)['quantidade_ocorrencias']
      end

      def protest_value(data)
        last_protest(data)['valor_protesto']
      end

      def protest_last_occurrence(data)
        last_occurrence = last_protest(data)['data_protesto']
        Date.parse(last_occurrence)
      end

      def count_lawsuit(data)
        data.size
      end

      def lawsuit_value(data)
        data.reduce(0) do |total, n|
          total + n['valor_acao']
        end
      end

      def lawsuit_last_occurrence(data)
        first_occurrence = Date.parse(data.first['data_acao_judicial'])
        data.inject(first_occurrence) do |fo, lo|
          last_occurrence = Date.parse(lo['data_acao_judicial'])
          return last_occurrence if last_occurrence > first_occurrence

          fo
        end
      end

      def last_pefin(data)
        return nil unless data.any?

        @last_pefin ||= data.inject(data.first) do |last, current|
          current_date = Date.parse(current['data_ocorrencia'])
          last_date = Date.parse(last['data_ocorrencia'])

          current_date > last_date ? current : last
        end
      end

      def last_refin(data)
        return nil unless data.any?
        @last_refin ||= data.inject(data.first) do |last, current|
          current_refin = Date.parse(current['data_ocorrencia'])
          last_refin = Date.parse(last['data_ocorrencia'])
          return current if current_refin > last_refin

          last
        end
      end

      def last_serasa_search_date(data)
        return nil unless data.any?
        first_hash = data.first.with_indifferent_access
        first_date = Date.new(first_hash[:ano_consulta] + 2000, first_hash[:mes_consulta], 1)
        @last_serasa_search ||= data.inject(first_date) do |fd, serasa_search|
          occurrence = Date.new(serasa_search['ano_consulta'] + 2000, serasa_search['mes_consulta'], 1)
          return occurrence if occurrence > fd

          fd
        end
      end

    end
  end
end
