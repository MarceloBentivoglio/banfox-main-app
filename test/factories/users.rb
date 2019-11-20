FactoryBot.define do
  factory :user do 
    seller
    email { "developer@banfox.com.br" }
    password { '12341234' }

    trait :auth_admin do
      admin { true }
    end

    trait :remote_original_ip do
      remote_original_ip { "177.69.125.17" }
    end

  end
end
