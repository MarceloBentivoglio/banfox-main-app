FactoryBot.define do
  factory :seller do
    full_name { "rodrigo santini" }
    cpf { "80287301087" }
    rf_full_name { "seed" }
    rf_sit_cad { "seed" }
    birth_date { "11121952" }
    mobile { "11998308090" }
    company_name { "biort implantes não admin ltda" }
    company_nickname { "" }
    cnpj { "16532989000114" }
    phone { "11998308090" }
    website { "asdfg" }
    address { "rua do rocio" }
    address_number { "450" }
    address_comp { "" }
    neighborhood { "vila olímpia" }
    state { "sp" }
    city { "são paulo" }
    zip_code { "04552000" }
    inscr_est { "" }
    inscr_mun { "" }
    nire { "" }
    company_type { "company_type_not_set" }
    monthly_revenue_cents { 12341234 }
    monthly_revenue_currency { "BRL" }
    monthly_fixed_cost_cents { 2341 }
    monthly_fixed_cost_currency { "BRL" }
    monthly_units_sold { 2345 }
    cost_per_unit_cents { 23451 }
    cost_per_unit_currency { "BRL" }
    debt_cents { 342 }
    debt_currency { "BRL" }
    full_name_partner { "rodrigo santini main" }
    cpf_partner { "80287301087" }
    rf_full_name_partner { "Rodrigo Santini Main" }
    rf_sit_cad_partner { "regular" }
    birth_date_partner { "11121952" }
    mobile_partner { "11998308090" }
    email_partner { "joaquim@banfox.com.br" }
    consent { true }
    fator { 0.45e-1 }
    advalorem { 0.5e-2 }
    protection { 0.15e0 }
    operation_limit_cents { 10000000 }
    operation_limit_currency { "BRL" }
    validation_status { "active" }
    visited { true }
    analysis_status { "approved" }
    rejection_motive { "rejection_motive_non_applicable" }
    created_at { "2019-07-16 15:36:16" }
    updated_at { "2019-07-16 15:36:16" }
    tax_regime { nil }

    trait :can_operate do
      allowed_to_operate { true }
    end
  end
end
