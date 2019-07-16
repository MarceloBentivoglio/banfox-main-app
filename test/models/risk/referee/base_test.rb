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

      test 'configure Risk title' do
        expected = 'Very Specific Referee'
        assert_equal expected, SpecificReferee.new.title
      end

      test 'configure Risk code' do
        expected = 'Risk 0001'
        assert_equal expected, SpecificReferee.new.code
      end

      test 'configure Risk description' do
        expected = 'Very specific description'
        assert_equal expected, SpecificReferee.new.description
      end
    end
  end
end
