FactoryBot.define do
  factory :checking_account do
    seller
    document { "12345678901" }
    name { "Sr. MyString" }
    account_number { "123" }
    branch { "Agência" }
    bank_code { "044" }
    bank_name { "Banco BVA S.A." }
  end
end
