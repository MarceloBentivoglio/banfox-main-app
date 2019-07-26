FactoryBot.define do
  factory :analyzed_part, class: 'Risk::AnalyzedPart' do
    key_indicator_report { nil }
    cnpj { "MyString" }
  end
end
