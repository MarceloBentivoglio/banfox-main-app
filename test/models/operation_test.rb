require 'test_helper'

class OperationTest < ActiveSupport::TestCase
  setup do
    using_shared_operation #test_helper
  end

  test '.payers returns all payers without repetition' do
    assert_equal 2, @operation.payers.count
  end

  test '.seller returns the correct seller' do
    assert_equal @seller, @operation.seller
  end
end
