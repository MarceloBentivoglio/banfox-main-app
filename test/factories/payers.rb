FactoryBot.define do
  factory :payer do
    company_name { "hospital cristovão da gama s.a" }
    cnpj { "08728220000148" }
    inscr_est { "" }
    inscr_mun { "" }
    nire { nil }
    company_type { nil }
    email { nil }
    phone { nil }
    address { "rua jacob luchesi" }
    address_number { "3240" }
    address_comp { "" }
    neighborhood { "santa catarina" }
    state { "rs" }
    city { "caxias do sul" }
    zip_code { "95032000" }
    import_ref { nil }
    fator { 0.45e-1 }
    advalorem { 0.5e-2 }
    created_at { "2019-07-16 19:24:52" }
    updated_at { "2019-07-16 19:24:52" }
  end
end
