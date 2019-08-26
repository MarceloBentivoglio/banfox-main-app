require 'test_helper'

class Risk::Parser::SerasaTest < ActiveSupport::TestCase
  def raw_data(file_example)
    @file ||= File.open("#{Rails.root}/test/support/files/#{file_example}")
    @file.read
  end

  test '.call with diadema' do
    external_data = FactoryBot.create(:external_datum, :serasa_diadema)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
    binding.pry
  end

  test '.call with ambev' do
    external_data = FactoryBot.create(:external_datum, :serasa_ambev)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
  end

  test '.call with carrefour' do
    external_data = FactoryBot.create(:external_datum, :serasa_carrefour)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
  end

  test '.call with hutchinson' do
    external_data = FactoryBot.create(:external_datum, :serasa_hutchinson)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
  end

  test '.call with marka' do
    external_data = FactoryBot.create(:external_datum, :serasa_marka)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)

    #Testing for Referee::FoundedIn
    expected = Date.new(2003, 8, 1)
    actual = Date.parse(data["05888701"][:company_data][:founded_in])
    assert_equal  expected, actual

    #Testing for Referee::PartnerEntryDate
    expected = Date.new(2003, 9,3)
    actual = Date.parse(data["05888701"][:partner_documents].first[:entry_date])
    assert_equal expected, actual
  end

  test '.call with nadir' do
    external_data = FactoryBot.create(:external_datum, :serasa_nadir)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
  end

  test '.call with biort' do
    external_data = FactoryBot.create(:external_datum, :serasa_biort)

    @parser = Risk::Parser::Serasa.new
    data = @parser.call(external_data)
  end
end
