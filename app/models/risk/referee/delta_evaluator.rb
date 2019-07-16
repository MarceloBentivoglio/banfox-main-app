module Risk
  module Referee
    module DeltaEvaluator

      def evaluate_delta_for_negative_information(historic, current)
        if @entities.size < 2
          @key_indicator_factory.build(self).gray!
        else
          absolute_delta = (current - historic).to_f
          if historic == 0
            if absolute_delta == 0
              @key_indicator_factory.build(self).green!
            else
              @key_indicator_factory.build(self).yellow!
            end
          else
            relative_delta = absolute_delta / historic
            if relative_delta <= @params[:green_limit]
              @key_indicator_factory.build(self).green!
            elsif relative_delta <= @params[:yellow_limit]
              @key_indicator_factory.build(self).yellow!
            else
              @key_indicator_factory.build(self).red!
            end
          end
        end
      end

    end
  end
end
