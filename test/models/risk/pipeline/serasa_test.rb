require 'test_helper'

class Risk::Pipeline::SerasaTest < ActiveSupport::TestCase
  setup do
    using_shared_operation

    @cnpj_1 = '55.219.241/0001-18'
    @cnpj_2 = '15.310.278/0001-32'
    @cnpj_3 = '28.153.804/0001-40'

    historic_evidence_1 = {
      'serasa_api' => {
        @cnpj_1 => {
          'refin': [
            {
              total_value: 1000,
              quantity: 0
            }
          ],
          'lawsuit': []
        },
        @cnpj_2 => {
          'refin': [
            {
              total_value: 1000,
              quantity: 10
            }
          ],
          'lawsuit': [
            {
              quantity: 10
            }
          ]
        }
      }
    }

    historic_evidence_2 = {
      'serasa_api' => {
        @cnpj_1 => {
          refin: [
            {
              total_value: 2000,
              quantity: 10
            }
          ]
        },
        @cnpj_3 => {
          refin: [
            {
              total_value: 3000,
              quantity: 15
            }
          ],
          lawsuit: [
            {
              quantity: 10
            }
          ]
        }
      }
    }

    current_evidence = {
      'serasa_api' => {
        @cnpj_2 => {
          refin: [
            {
              total_value: 1001,
              quantity: 16
            }
          ],
          lawsuit: [
            {
              quantity: 10
            }
          ]
        },
        @cnpj_3 => {
          refin: [
            {
              total_value: 1002,
              quantity: 5
            }
          ],
          lawsuit: [
            {
              quantity: 16
            }
          ]
        }
      }
    }

    #Historic Data
    @kir_1 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_1, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_1.id, cnpj: @cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_1.id, cnpj: @cnpj_2)

    @kir_2 = FactoryBot.create(:key_indicator_report, evidences: historic_evidence_2, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_2.id, cnpj: @cnpj_1)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @kir_2.id, cnpj: @cnpj_3)

    @current_kir = FactoryBot.create(:key_indicator_report, evidences: current_evidence, operation_id: @operation.id)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @current_kir.id, cnpj: @cnpj_2)
    FactoryBot.create(:analyzed_part, key_indicator_report_id: @current_kir.id, cnpj: @cnpj_3)
  end

  test '.build_evidences_with_historic' do
    pipeline = Risk::Pipeline::RecurrentOperation::Serasa.new(@current_kir)

    expected = {
      "serasa_api"=> {
        "15.310.278/0001-32"=> {
          "refin"=> [
             {
               "total_value"=>1001,
               "quantity"=>16
             }
          ],
          "lawsuit"=> [
            {
              "quantity"=>10
            }
          ],
          "historic"=> [
            {
              "refin"=>[
                {
                  "total_value"=>1000,
                  "quantity"=>10
                }
              ],
              "lawsuit"=> [
                {
                  "quantity"=>10
                }
              ]
            }
          ]
        },
        "28.153.804/0001-40"=> {
          "refin"=> [
            {
              "total_value"=>1002,
              "quantity"=>5
            }
          ],
          "lawsuit"=> [
            {
              "quantity"=>16
            }
          ],
          "historic"=> [
            {
              "refin"=> [
                {
                  "total_value"=>3000,
                  "quantity"=>15
                }
              ],
              "lawsuit"=> [
                {
                  "quantity"=>10
                }
              ]
            }
          ]
        }
      }
    }

    assert_equal expected, pipeline.build_evidences_with_historic
  end

  test '.call run referees' do
    Risk::Pipeline::RecurrentOperation::Serasa.new(@current_kir).call

    expected = Risk::KeyIndicatorReport::YELLOW_FLAG
    assert_equal expected, @current_kir.key_indicators[@cnpj_2]['refin_value_delta']["flag"]

    expected = Risk::KeyIndicatorReport::GREEN_FLAG
    assert_equal expected, @current_kir.key_indicators[@cnpj_3]['refin_value_delta']["flag"]

    expected = Risk::KeyIndicatorReport::RED_FLAG
    assert_equal expected, @current_kir.key_indicators[@cnpj_2]['refin_quantity_delta']["flag"]

    expected = Risk::KeyIndicatorReport::GREEN_FLAG
    assert_equal expected, @current_kir.key_indicators[@cnpj_3]['refin_quantity_delta']["flag"]
  end
end
