module Risk
  module Referee
    class ShareCapital < Base
      def initialize(key_indicator_factory, corporate_control)
        @key_indicator_factory = key_indicator_factory
        @corporate_control = corporate_control
        @code = ''
        @title = ''
        @description = ''
      end

      def call
        share_capital = @corporate_control.share_capital
        if share_capital < 10_000
          @key_indicator_factory.build(self).red!
        elsif share_capital >= 10_000 && share_capital < 50_000
          @key_indicator_factory.build(self).yellow!
        else
          @key_indicator_factory.build(self).green!
        end
      end
    end
  end
end
