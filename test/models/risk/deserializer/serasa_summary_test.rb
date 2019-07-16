require 'test_helper'

class Risk::Deserializer::SerasaSummaryTest < ActiveSupport::TestCase
  def subject
    @subject ||= Risk::Deserializer::SerasaSummary.new(serasa_data)
  end

  def nogord_response
    file_data = File.open("#{Rails.root}/test/support/files/nogord_serasa_example.json").read
    JSON.parse(file_data)
  end

  def serasa_data
    nogord_response['info']['external_sources'].first['data']
  end

  test '.call' do
    expected = {
      serasa_searches: {
        quantity: 194,
        last_occurrence: Date.new(2019, 6, 1)
      },
      pefin: {
        quantity: 45,
        value: 407,
        last_occurrence: Date.new(2019, 1, 21)
      },
      refin: {
        quantity: 9,
        value: 12857,
        last_occurrence: Date.new(2018,11,22)
      },
      protest: {
        quantity: 276,
        value: 1560,
        last_occurrence: Date.new(2019, 5, 9)
      },
      lawsuit: {
        quantity: 2,
        value: 762504,
        last_occurrence: Date.new(2018, 5, 28)
      },
      check_ccf: {
        quantity: 12,
        value: 0,
        last_occurrence: Date.new(2018, 6, 26)
      },
    }.with_indifferent_access

    assert_equal expected, subject.call
  end

  test '.last_serasa_search' do
    data = [
      {
        "ano_consulta": 19,
        "mes_consulta": 3,
        "descricao_mes_consulta": "MAR",
      }.with_indifferent_access,
      {
        "ano_consulta": 19,
        "mes_consulta": 6,
        "descricao_mes_consulta": "JUN",
      }.with_indifferent_access,
      {
        "ano_consulta": 19,
        "mes_consulta": 5,
        "descricao_mes_consulta": "MAI",
      }.with_indifferent_access,
    ]

    expected = Date.new(2019, 6, 1)
    assert_equal expected, subject.last_serasa_search_date(data)
  end

  test '.count_company_searches' do
    data = [
      {
        'quantidade_consulta_por_empresa' => 10
      },
      {
        'quantidade_consulta_por_empresa' => 10
      }
    ]

    assert_equal 20, subject.count_company_searches(data)
  end

  test '.count_financial_company_searches' do
    data = [
      {
        'quantidade_consulta_por_financeira' => 15
      },
      {
        'quantidade_consulta_por_financeira' => 15
      }
    ]
    assert_equal 30, subject.count_financial_company_searches(data)
  end


  test '.last_pefin' do
    data = [
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "21/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "26/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      },
    ]

    expected = {
      'quantidade_pendencias_financeiras' => 45,
      'valor' => 150 ,
      'data_ocorrencia' => "26/01/2019"
    }

    assert_equal expected, subject.last_pefin(data)
  end

  test '.count_pefin' do
    data = [
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      }
    ]

    assert_equal 45, subject.count_pefin(data)
  end

  test '.pefin_value' do
    data = [
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      }
    ]

    assert_equal 150, subject.pefin_value(data)
  end

  test '.pefin_last_occurrence' do
    data = [
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "26/01/2019"
      }
    ]

    assert_equal Date.new(2019, 1 ,26), subject.pefin_last_occurrence(data)
  end

  test '.last_refin' do
    data = [
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "24/01/2019"
      },
      {
        'quantidade_pendencias_financeiras' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      }

    ]

    expected = {
      'quantidade_pendencias_financeiras' => 45,
      'valor' => 150 ,
      'data_ocorrencia' => "24/01/2019"
    }

    assert_equal expected, subject.last_refin(data)
  end

  test '.count_refin' do
    data = [
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      },
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      }
    ]

    assert_equal 45, subject.count_refin(data)
  end

  test '.refin_value' do
    data = [
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      },
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      }
    ]

    assert_equal 150, subject.refin_value(data)
  end

  test '.refin_last_occurrence' do
    data = [
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "23/01/2019"
      },
      {
        'quantidade_refinanciamento' => 45,
        'valor' => 150 ,
        'data_ocorrencia' => "22/01/2019"
      }
    ]

    assert_equal Date.new(2019, 1, 23), subject.refin_last_occurrence(data)
  end

  test '.last_protest' do
    data = [
      {
        "data_protesto" => "09/04/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560
      },
      {
        "data_protesto" => "09/05/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560
      }
    ]

    expect = {
      "data_protesto" => "09/05/2019",
      "moeda" => "R$",
      "valor_protesto" => 1560
    }

    assert_equal expect, subject.last_protest(data)
  end

  test '.count_protest' do
    data = [
      {
        "data_protesto" => "09/04/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100
      },
      {
        "data_protesto" => "09/05/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100,
      }
    ]

    assert_equal 100, subject.count_protest(data)
  end

  test '.protest_value' do
    data = [
      {
        "data_protesto" => "09/04/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100
      },
      {
        "data_protesto" => "09/05/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100,
      }
    ]

    assert_equal 1560, subject.protest_value(data)
  end

  test '.protest_last_occurrence' do
    data = [
      {
        "data_protesto" => "09/04/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100
      },
      {
        "data_protesto" => "09/05/2019",
        "moeda" => "R$",
        "valor_protesto" => 1560,
        "quantidade_ocorrencias" => 100,
      }
    ]

    assert_equal Date.new(2019, 5, 9), subject.protest_last_occurrence(data)
  end

  test '.count_lawsuit' do
    data = [
      {
        'quantidade_ocorrencias': 2,
        'data_acao_judicial': '28/05/2018',
        'moeda': 'R$',
        'valor_acao': 129759
      },
      {
        'quantidade_ocorrencias': 2,
        'data_acao_judicial': '07/04/2017',
        'moeda': 'R$',
        'valor_acao': 632745
      }
    ]

    assert_equal 2, subject.count_lawsuit(data)
  end

  test '.lawsuit_value' do
    data = [
      {
        'quantidade_ocorrencias'=> 2,
        'data_acao_judicial'=> '28/05/2018',
        'moeda'=> 'R$',
        'valor_acao'=> 129759
      },
      {
        'quantidade_ocorrencias'=> 2,
        'data_acao_judicial'=> '07/04/2017',
        'moeda'=> 'R$',
        'valor_acao'=> 632745
      }
    ]

    assert_equal 762504, subject.lawsuit_value(data)
  end

  test '.lawsuit_last_occurrence' do
    data = [
      {
        'quantidade_ocorrencias'=> 2,
        'data_acao_judicial'=> '28/05/2018',
        'moeda'=> 'R$',
        'valor_acao'=> 129759
      },
      {
        'quantidade_ocorrencias'=> 2,
        'data_acao_judicial'=> '07/04/2017',
        'moeda'=> 'R$',
        'valor_acao'=> 632745
      }
    ]

    test_data = subject.lawsuit_last_occurrence(data)

    assert_equal Date.new(2018,5,28), test_data
  end

  test '.count_searches_serasa' do
    data = [
      {
        'quantidade_consulta_por_empresa' => 10,
        'quantidade_consulta_por_financeira' => 15
      },
      {
        'quantidade_consulta_por_empresa' => 10,
        'quantidade_consulta_por_financeira' => 15
      }
    ]
    assert_equal 50, subject.count_serasa_searches(data)
  end

  test '.check_ccf' do
    #      "informacoes_recheque_cheque_sem_fundo_ccf": [
    input_data = [
      {
        "quantidade_ocorrencias": 12,
        "data": "26/06/2018",
        "cheque": "CCF-BB",
        "quantidade_no_banco": 12,
        "banco": "B DO BRASIL",
        "agencia": "2168",
        "cidade": "ITAPECERICA DA SERRA",
        "uf": "SP",
        "codigo_natureza": "",
        "reservado_serasa": "IPZ0O0125894697044281038"
      }.with_indifferent_access,
      {
        "quantidade_ocorrencias": 14,
        "data": "26/05/2018",
        "cheque": "CCF-BB",
        "quantidade_no_banco": 12,
        "banco": "B DO BRASIL",
        "agencia": "2168",
        "cidade": "ITAPECERICA DA SERRA",
        "uf": "SP",
        "codigo_natureza": "",
        "reservado_serasa": "IPZ0O0125894697044281038"
      }.with_indifferent_access
    ]

    expected = {
      quantity: 12,
      value: 0,
      last_occurrence: Date.new(2018, 6, 26)
    }

    assert_equal expected, subject.check_ccf(input_data)
  end
end
