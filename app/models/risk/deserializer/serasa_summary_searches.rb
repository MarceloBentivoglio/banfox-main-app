module Risk
  module Deserializer
    class SerasaSummarySearches
      def call(data)
        current_date = Date.current
        current_year_two_digits = current_date.year - 2000

        per_month = data.select {|search_data| search_data[:ano_consulta] == current_year_two_digits }
        per_month_last_year = data.select {|search_data| search_data[:ano_consulta] != current_year_two_digits }

        {
          per_month: parse_serasa_search(per_month),
          per_month_last_year: parse_serasa_search(per_month_last_year)
        }
      end

      def parse_serasa_search(data)
        data_hash = {}
        data.each do |search_data|
          data_hash[:"#{search_data[:mes_consulta]}"] = {
            company: search_data[:quantidade_consulta_por_empresa],
            financial: search_data[:quantidade_consulta_por_financeira]
          }
        end

        data_hash
      end

    end
  end
end
