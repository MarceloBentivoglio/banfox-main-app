module Risk
  module Referee
    class SerasaQueries < Base
      def initialize(evidences)
        @evidence = {
          names: evidences.serasa_query_names,
        }
        @code = 'serasa_queries'
        @title = 'Serasa Queries'
        @description = ''
        @params = {
          keywords: [
            'fomento',
            'banco',
            'securitizadora',
            'fundo',
            'fidc',
            'gestao de risco',
            'gestao de r',
            'financeira',
            'credito',
            'financiame',
            'financiamento',
            'gestao riscos',
            'cef',
            'cred'
          ],
          ignore_names: [
            'MVP FOMENTO MERCANTIL LTDA',
          ],
          green_limit: 1
        }

        @evidence[:found] = select_names_with_correspondent_keywords
      end

      def select_names_with_correspondent_keywords
        @evidence[:names]&.select do |name|
                            found = @params[:keywords].select {|keyword| name.downcase.include? keyword }
                            found.any?
                         end&.reject do |name|
                           @params[:ignore_names].include? name
                         end
      end

      def quantity_found
        @evidence[:found]&.uniq&.size
      end

      def assert
        return Risk::KeyIndicatorReport::GRAY_FLAG if @evidence[:found].nil?
        if quantity_found <= @params[:green_limit]
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          Risk::KeyIndicatorReport::YELLOW_FLAG
        end
      end
    end
  end
end
