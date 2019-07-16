require 'test_helper'

class Risk::KeyIndicatorFactoryTest < ActiveSupport::TestCase

  def subject
    @key_indicator_factory ||= Risk::KeyIndicatorFactory.new
  end

  class SpecificReferee < Risk::Referee::Base
    def initialize
      @code = 'Risk 0001'
      @title = 'Very specific referee'
      @description = 'Very specific description'
      @params = {green_limit: 0, yellow_limit: 0.5}
    end

    def call
    end
  end

  def specific_referee
    @specific_referee ||= SpecificReferee.new
  end

  test '.build should return a KeyIndicator instance' do
    expected = Risk::KeyIndicator
    assert_kind_of expected, subject.build(specific_referee)
  end

  test '.build should return a KeyIndicator instance with the SpecificReferee instance configuration ' do
    Risk::KeyIndicator.expects(:new).with({
      code: 'Risk 0001',
      title: 'Very specific referee',
      description: 'Very specific description',
      params: {green_limit: 0, yellow_limit: 0.5}
    })

    subject.build(specific_referee)
  end

end
