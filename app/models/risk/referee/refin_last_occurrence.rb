module Risk
  module Referee
    class RefinLastOccurrence < Base
      def initialize(evidences)
        @evidence = { 
          refin: evidences.refin
        }
        @code = 'refin_last_occurrence'
        @title = 'Refin Last Occurrence'
        @description = ''
        @params = {
          yellow_limit: 30,
          green_limit: 5
        }
      end

      def assert
        refin_last_occurrence = Date.parse(@evidence[:refin]&.first['date'])

        if @evidence[:refin].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        elsif @evidence[:refin].empty?
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          if refin_last_occurrence.nil?
            Risk::KeyIndicatorReport::GRAY_FLAG
          else
            days_difference = Date.current.mjd - (refin_last_occurrence.mjd || 0)

            if days_difference <= @params[:green_limit]
              Risk::KeyIndicatorReport::GREEN_FLAG
            elsif days_difference <= @params[:yellow_limit]
              Risk::KeyIndicatorReport::YELLOW_FLAG
            else
              Risk::KeyIndicatorReport::RED_FLAG
            end
          end
        end
      end
    end
  end
end
