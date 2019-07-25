require 'test_helper'

class Risk::Pipeline::SerasaTest < ActiveSupport::TestCase
  test '.build_evidences_with_historic' do
    using_shared_operation

    cnpj_1 = '55.219.241/0001-18'
    cnpj_2 = '15.310.278/0001-32'
    cnpj_3 = '28.153.804/0001-40'

    historic_evidence_1 = {
      cnpj_1 => {
        'refin': {
          value: 1000
        },
      },
      cnpj_2 => {
        'refin': {
          value: 1000
        }
      }
    }

    historic_evidence_2 = {
      cnpj_1 => {
        refin: {
          value: 2000
        }
      },
      cnpj_3 => {
        refin: {
          value: 3000
        }
      }
    }

    current_evidence = {
      cnpj_2 => {
        refin: {
          value: 1001
        }
      },
      cnpj_3 => {
        refin: {
          value: 1002
        }
      }
    }

    #Historic Data
    kir_1 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_1, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: kir_1.id, cnpj: cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: kir_1.id, cnpj: cnpj_2)

    kir_2 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_2, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: kir_2.id, cnpj: cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: kir_2.id, cnpj: cnpj_3)

    current_kir = FactoryBot.create(:key_indicator_report, evidences: current_evidence, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: current_kir.id, cnpj: cnpj_2)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: current_kir.id, cnpj: cnpj_3)

    pipeline = Risk::Pipeline::Serasa.new(current_kir)

    expected = {
      cnpj_2 => {
        'refin' => {
          'value' => 1001
        },
        historic: [
          {
            'refin' => {
              'value' => 1000
            }
          }
        ]
      },
      cnpj_3 => {
        'refin' => {
          'value' => 1002
        },
        historic: [
          {
            'refin' => {
              'value' => 3000
            }
          }
        ]
      }
    }

    assert_equal expected, pipeline.build_evidences_with_historic
  end
end
