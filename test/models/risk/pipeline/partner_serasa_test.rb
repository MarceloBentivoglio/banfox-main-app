require 'test_helper'

class Risk::Pipeline::PartnerSerasaTest < ActiveSupport::TestCase
  setup do
    using_shared_operation

    @cnpj_1 = '55.219.241/0001-18'
    @cnpj_2 = '15.310.278/0001-32' 
    @cnpj_3 = '28.153.804/0001-40'
    @cpf_1 = '555.796.870-95'
    @cpf_2 = '577.867.500-37'
    @cpf_3 = '11.508.020-57'
    @cpf_4 = '075.489.190-93'

    historic_evidence_1 = {
      'serasa_api' => {
        @cnpj_1 => {
          'partner_data' => [
            {
              'cpf': @cpf_1,
              'refin': [
                {
                  value: 1000
                }
              ]
            },
            {
              'cpf': @cpf_2,
              'refin': [
              ]
            }
          ]
        },
        @cnpj_2 => {
          'partner_data' => [
            {
              'cpf': @cpf_3,
              'refin': [
              ]
            }
          ]
        }
      }
    }

    historic_evidence_2 = {
      'serasa_api' => {
        @cnpj_3 => {
          'partner_data' => [
            {
              'cpf': @cpf_4,
              'refin': [
                {
                  value: 1000
                }
              ]
            }
          ]
        },
        @cnpj_2 => {
          'partner_data' => [
            {
              'cpf': @cpf_3,
              'refin': [
                {
                  value: 1000
                }
              ]
            }
          ]
        }
      }
    }

    current_evidence = {
      'serasa_api' => {
        @cnpj_1 => {
          'partner_data' => [
            {
              'cpf': @cpf_1,
              'refin': [
                {
                  value: 1000
                }
              ]
            },
            {
              'cpf': @cpf_2,
              'refin': [
              ]
            }
          ]
        },
        @cnpj_2 => {
          'partner_data' => [
            {
              'cpf': @cpf_3,
              'refin': [
              ]
            }
          ]
        }
      }
    }

    @kir_1 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_1, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_1.id, cnpj: @cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_1.id, cnpj: @cnpj_2)

    @kir_2 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_2, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_2.id, cnpj: @cnpj_2)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_2.id, cnpj: @cnpj_3)

    @current_kir = FactoryBot.create(:key_indicator_report, evidences: current_evidence, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @current_kir.id, cnpj: @cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @current_kir.id, cnpj: @cnpj_2)
  end

  test '.build_partner_historic_evidence' do
    expected = {
      'serasa_api' => {
        @cnpj_1 => {
          'partner_data' => [
            {
              'cpf' => @cpf_1,
              'refin' => [
                {
                  'value' => 1000
                },
              ],
              'historic' => [
                {
                  'cpf' => @cpf_1,
                  'refin' => [
                    {
                      'value' => 1000
                    }

                  ]
                }
              ]
            },
            {
              'cpf' => @cpf_2,
              'refin' => [
              ],
              'historic' => [
                {
                  'cpf' => @cpf_2,
                  'refin' => [
                  ]
                }
              ]
            }
          ]
        },
        @cnpj_2 => {
          'partner_data' => [
            {
              'cpf' => @cpf_3,
              'refin' => [
              ],
              'historic' => [
                {
                  'cpf' => @cpf_3,
                  'refin' => [
                    {
                      'value' => 1000 
                    }
                  ]
                },
                {
                  'cpf' => @cpf_3,
                  'refin' => [
                  ]
                }
              ]
            }
          ]
        }
      }
    }

    pipeline = Risk::Pipeline::RecurrentOperation::PartnerSerasa.new(@current_kir)
    assert_equal expected, pipeline.build_evidences
  end

  test '.call' do
    pipeline = Risk::Pipeline::RecurrentOperation::PartnerSerasa.new(@current_kir)
    pipeline.call
  end
end
