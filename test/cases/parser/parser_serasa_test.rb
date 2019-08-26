require 'test_helper'

class ParserSerasaTest < ActiveSupport::TestCase

setup do
  @external_datum = FactoryBot.create(:external_datum, :serasa_diadema)
end

test '.call' do
  expected = {

  }
  assert_equal(expected, Risk::Parser::Serasa.new(@external_datum).call)
end

end

