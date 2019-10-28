require 'test_helper'

class Risk::Referee::SerasaQueriesTest < ActiveSupport::TestCase
  test '.call correctly returns a green flag' do
    production_data = {
      serasa_queries: [
        {
          :date=>"20190627",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0002",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190626",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0001",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190614",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0001",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190614",
          :name=>"BANCO SANTANDER BRASIL S/A         ",
          :quantity=>"0001",
          :cnpj=>"090400888"
        },
        {
          :date=>"20190604",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0002",
          :cnpj=>"023198636"
        }
      ]
    }.with_indifferent_access

    decorated_evidences = Risk::Decorator::Serasa.new(production_data)
    assert_equal Risk::KeyIndicatorReport::GREEN_FLAG, Risk::Referee::SerasaQueries.new(decorated_evidences).call[:flag]
  end

  test '.call correctly returns a yellow flag' do
    production_data = {
      serasa_queries: [
        {
          :date=>"20190627",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0002",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190626",
          :name=>"BANCO SANTANDER BRASIL S/A         ",
          :quantity=>"0001",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190614",
          :name=>"MVP FOMENTO MERCANTIL LTDA         ",
          :quantity=>"0001",
          :cnpj=>"023198636"
        },
        {
          :date=>"20190614",
          :name=>"BANCO SANTANDER BRASIL S/A         ",
          :quantity=>"0001",
          :cnpj=>"090400888"
        },
        {
          :date=>"20190604",
          :name=>"FOMENTO BANCO SECURITIZADORA         ",
          :quantity=>"0002",
          :cnpj=>"023198636"
        }
      ]
    }.with_indifferent_access

    decorated_evidences = Risk::Decorator::Serasa.new(production_data)
    
    assert_equal Risk::KeyIndicatorReport::YELLOW_FLAG, Risk::Referee::SerasaQueries.new(decorated_evidences).call[:flag]
  end

end
