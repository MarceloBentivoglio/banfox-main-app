require 'test_helper'

class ParserSerasaTest < ActiveSupport::TestCase

  setup do
    @external_datum = FactoryBot.create(:external_datum, :serasa_diadema)
  end

  #TODO
  #Get the exact result and assert to garantee future compatibility
  test '.call' do
    Risk::Parser::Serasa.new.call(@external_datum)
  end

end

