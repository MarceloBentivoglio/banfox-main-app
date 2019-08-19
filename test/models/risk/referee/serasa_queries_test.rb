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
    expected = {
      code: 'serasa_queries',
      title: 'Serasa Queries',
      description: '',
      params: {
        keywords: [
          'fomento',
          'banco',
          'securitizadora',
          'fundo',
          'fidc'
        ],
        ignore_names: [
          'MVP FOMENTO MERCANTIL LTDA',
        ],
        green_limit: 1
      },
      evidence: {
        names: [
          'MVP FOMENTO MERCANTIL LTDA',
          'MVP FOMENTO MERCANTIL LTDA',
          'MVP FOMENTO MERCANTIL LTDA',
          'BANCO SANTANDER BRASIL S/A',
          'MVP FOMENTO MERCANTIL LTDA',
        ],
        found: [
          'BANCO SANTANDER BRASIL S/A',
        ],
      },
      flag: Risk::KeyIndicatorReport::GREEN_FLAG
    }

    assert_equal expected, Risk::Referee::SerasaQueries.new(decorated_evidences).call
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
    expected = {
      code: 'serasa_queries',
      title: 'Serasa Queries',
      description: '',
      params: {
        keywords: [
          'fomento',
          'banco',
          'securitizadora',
          'fundo',
          'fidc'
        ],
        ignore_names: [
          'MVP FOMENTO MERCANTIL LTDA',
        ],
        green_limit: 1
      },
      evidence: {
        names: [
          'MVP FOMENTO MERCANTIL LTDA',
          'BANCO SANTANDER BRASIL S/A',
          'MVP FOMENTO MERCANTIL LTDA',
          'BANCO SANTANDER BRASIL S/A',
          'FOMENTO BANCO SECURITIZADORA',
        ],
        found: [
          'BANCO SANTANDER BRASIL S/A',
          'BANCO SANTANDER BRASIL S/A',
          'FOMENTO BANCO SECURITIZADORA',
        ],
      },
      flag: Risk::KeyIndicatorReport::YELLOW_FLAG
    }

    assert_equal expected, Risk::Referee::SerasaQueries.new(decorated_evidences).call
  end

end
