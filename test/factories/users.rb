FactoryBot.define do
  factory :user do 
    seller
    email { "developer@banfox.com.br" }
    password { '12341234' }

    trait :auth_admin do
      admin { true }
    end

  end
end
