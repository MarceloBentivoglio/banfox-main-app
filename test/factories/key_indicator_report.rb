FactoryBot.define do
  factory :key_indicator_report, class: 'Risk::KeyIndicatorReport' do
    input_data do 
      {
        payers: [
          "08728220000148"
        ],
        seller:  "16532989000114",
        kind: 'recurrent_operation'
      }
    end

    kind { 'operation_part' }
    ttl { DateTime.new(2019,2,3) }

    trait :with_indicators do
      key_indicators do
        {
          '07526557000100' => {
            'pefin_value_delta' => {
              'flag' => 0
            },
            'pefin_quantity_delta' => {
              'flag' => -1
            }
          }
        }
      end
    end
  end
end
