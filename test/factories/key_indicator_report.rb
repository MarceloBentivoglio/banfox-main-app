FactoryBot.define do
  factory :key_indicator_report, class: 'Risk::KeyIndicatorReport' do
    input_data do 
      {
        cnpj: "00310523911323",
      }
    end

    kind { 'operation_part' }
    ttl { DateTime.new(2019,2,3) }
  end
end
