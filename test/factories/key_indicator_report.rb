FactoryBot.define do
  factory :key_indicator_report, class: 'Risk::KeyIndicatorReport' do
    input_data do 
      {
        cnpj: "00310523911323",
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
