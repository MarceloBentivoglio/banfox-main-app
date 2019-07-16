FactoryBot.define do
  factory :key_indicator, class: 'Risk::KeyIndicator' do
    name { "MyString" }
    description { "MyString" }
    flag { 1 }
    scope { 1 }
  end
end
