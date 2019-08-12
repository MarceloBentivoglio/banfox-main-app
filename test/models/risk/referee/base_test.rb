require 'test_helper'

module Risk
  module Referee
    class BaseTest < ActiveSupport::TestCase

      #Mocked classes
      class SpecificReferee < Risk::Referee::Base
        def initialize
          @code = 'Risk 0001'
          @title = 'Very Specific Referee'
          @description = 'Very specific description'
        end

        def call
        end
      end

      test '.assertions' do
      end
    end
  end
end
