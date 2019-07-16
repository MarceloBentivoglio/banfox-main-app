require 'test_helper'

class Risk::Referee::ShareCapitalTest < ActiveSupport::TestCase

  setup do
    key_indicator_factory = Risk::KeyIndicatorFactory.new
    @entity = Risk::Entity::Serasa::CorporateControl.new
    @referee = Risk::Referee::ShareCapital.new(key_indicator_factory, @entity)
  end

  test '.call generates a red flag' do
    @entity.share_capital = 6_000
    Risk::KeyIndicator.any_instance.expects(:red!)
    @referee.call
  end

  test '.call generates a yellow flag' do
    @entity.share_capital = 15_000
    Risk::KeyIndicator.any_instance.expects(:yellow!)
    @referee.call
  end

  test '.call generates a green flag' do
    @entity.share_capital = 50_000
    Risk::KeyIndicator.any_instance.expects(:green!)
    @referee.call
  end
end
