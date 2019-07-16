require 'test_helper'

class Risk::Deserializer::NogordSerasaTest < ::ActiveSupport::TestCase
  def subject
    @subject ||= Risk::Deserializer::NogordSerasa.new(serasa_data)
  end

  def nogord_response
    file_data = File.open("#{Rails.root}/test/support/files/nogord_serasa_example.json").read
    JSON.parse(file_data)
  end

  def serasa_data
    nogord_response['info']['external_sources'].first['data']
  end

  test '.call' do
    data = subject.call
    assert_equal true, data.keys.include?(:summary)
    assert_equal true, data.keys.include?(:corporate_control)
  end

  test '.corporate_control' do
    data = {
      "controle_societario_capital_social": {
        "data_ultima_atualizacao": "09/12/2018",
        "valor_capital_realizado": 651000,
        "valor_capital_autorizado": 0,
        "descricao_nacionalidade": "BRASIL",
        "descricao_origem": "PRIVADO",
        "descricao_natureza": "FECHADO",
        "monto_controle_societario_junta_comercial": "",
        "situacao_capital_total": "F",
        "valor_capital_social": 651000
      }
    }.with_indifferent_access

    expected = {
      share_capital: 651000,
      realized_capital: 651000
    }

    assert_equal expected, subject.corporate_control(data)
  end

  test '.admin_group' do
    #"quadro_administrativo_detalhes": [
    data = [
      {
        "identificacao": "F",
        "cnpj_cpf_socio": "508218908",
        "codigo_situacao_administrador": "09",
        "data_entrada": "30/09/1971",
        "codigo_socio_consistido": "7",
        "cnpj_sequencia": "0000",
        "digito_cpf": "59",
        "nome_administrador": "ESPOLIO DE HAROLDO CASTELLO BRANCO",
        "cargo": "DIRETOR",
        "nacionalidade": "BRASIL",
        "estado_civil": "CASADO",
        "data_inicio_mandato": "30/09/1971",
        "data_fim_mandato": "99999999",
        "indicador_restricao": "S",
        "codigo_cargo": "022"
      }.with_indifferent_access
    ]

    expected = [
      {
        fullname: "ESPOLIO DE HAROLDO CASTELLO BRANCO",
        cpf: '508218908',
        nationality: 'BRASIL',
        civil_state: 'CASADO',
        role: 'DIRETOR',
        sign_in_at: Date.new(1971,9,30)
      }
    ]

    assert_equal expected, subject.admin_group(data)
  end 

end
