require 'test_helper'

class Risk::Deserializer::SerasaSummarySearchesTest < ActiveSupport::TestCase

  def subject
    @subject ||= Risk::Deserializer::SerasaSummarySearches.new
  end
  test '.call' do
    input_data = [
      {
        "ano_consulta": 19,
        "mes_consulta": 6,
        "descricao_mes_consulta": "JUN",
        "quantidade_consulta_por_empresa": 2,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 19,
        "mes_consulta": 5,
        "descricao_mes_consulta": "MAI",
        "quantidade_consulta_por_empresa": 10,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 19,
        "mes_consulta": 4,
        "descricao_mes_consulta": "ABR",
        "quantidade_consulta_por_empresa": 17,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 19,
        "mes_consulta": 3,
        "descricao_mes_consulta": "MAR",
        "quantidade_consulta_por_empresa": 15,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 19,
        "mes_consulta": 2,
        "descricao_mes_consulta": "FEV",
        "quantidade_consulta_por_empresa": 20,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 19,
        "mes_consulta": 1,
        "descricao_mes_consulta": "JAN",
        "quantidade_consulta_por_empresa": 22,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 12,
        "descricao_mes_consulta": "DEZ",
        "quantidade_consulta_por_empresa": 8,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 11,
        "descricao_mes_consulta": "NOV",
        "quantidade_consulta_por_empresa": 20,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 10,
        "descricao_mes_consulta": "OUT",
        "quantidade_consulta_por_empresa": 12,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 9,
        "descricao_mes_consulta": "SET",
        "quantidade_consulta_por_empresa": 15,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 8,
        "descricao_mes_consulta": "AGO",
        "quantidade_consulta_por_empresa": 21,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 7,
        "descricao_mes_consulta": "JUL",
        "quantidade_consulta_por_empresa": 11,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 6,
        "descricao_mes_consulta": "JUN",
        "quantidade_consulta_por_empresa": 17,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      },
      {
        "ano_consulta": 18,
        "mes_consulta": 5,
        "descricao_mes_consulta": "MAI",
        "quantidade_consulta_por_empresa": 4,
        "quantidade_consulta_por_financeira": 0,
        "indicador_banco_ou_empresa": "A",
        "reservado": ""
      }
    ]

    expected = {
      per_month: {
        '6': { company: 2, financial: 0 },
        '5': { company: 10, financial: 0 },
        '4': { company: 17, financial: 0 },
        '3': { company: 15, financial: 0 },
        '2': { company: 20, financial: 0 },
        '1': { company: 22, financial: 0 },
      },
      per_month_last_year: {
        '12': { company: 8, financial: 0 },
        '11': { company: 20, financial: 0 },
        '10': { company: 12, financial: 0 },
        '9': { company: 15, financial: 0 },
        '8': { company: 21, financial: 0 },
        '7': { company: 11, financial: 0 },
        '6': { company: 17, financial: 0 },
        '5': { company: 4, financial: 0 },
      }
    }

    Date.stubs(:current).returns(Date.new(2019, 6, 10))
    assert_equal expected, subject.call(input_data)
  end
end
