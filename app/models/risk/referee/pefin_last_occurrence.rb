module Risk
  module Referee
    class PefinLastOccurrence < Base
      def initialize(evidences)
        @evidence = { 
          pefin: evidences.pefin
        }
        @code = 'pefin_last_occurrence'
        @title = 'Pefin Last Occurrence'
        @description = ''
        @params = {
          yellow_limit: 30,
          green_limit: 5
        }
      end

      def assert
        pefin_last_occurrence = @evidence[:pefin]&.first&.dig 'date'
        pefin_last_occurrence = Date.parse(pefin_last_occurrence) unless pefin_last_occurrence.nil?

        if @evidence[:pefin].nil?
          Risk::KeyIndicatorReport::GRAY_FLAG
        elsif @evidence[:pefin].empty?
          Risk::KeyIndicatorReport::GREEN_FLAG
        else
          if pefin_last_occurrence.nil?
            Risk::KeyIndicatorReport::GRAY_FLAG
          else
            days_difference = Date.current.mjd - (pefin_last_occurrence.mjd || 0)

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
