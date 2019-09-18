FactoryBot.define do
  factory :payment_credit do
    installment { "" }
    credit { 1 }
    paid_date { "2019-09-18" }
    seller { "" }
  end
end
