FactoryBot.define do
  factory :installment do
    number { "1" }
    value_cents { 4000000 }
    value_currency { "BRL" }
    initial_fator_cents { 0 }
    initial_fator_currency { "BRL" }
    initial_advalorem_cents { 0 }
    initial_advalorem_currency { "BRL" }
    initial_protection_cents { 0 }
    initial_protection_currency { "BRL" }
    due_date { "2019-09-12" }
    ordered_at { "2019-07-16 19:25:21" }
    deposited_at { nil }
    finished_at { nil }
    backoffice_status { "ordered" }
    liquidation_status { "liquidation_status_not_set" }
    unavailability { "unavailability_non_applicable" }
    rejection_motive { "rejection_motive_not_set" }
    import_ref { nil }
    created_at { "2019-07-16 19:24:54" }
    updated_at { "2019-07-16 19:25:21" }
    final_fator_cents { 0 }
    final_fator_currency { "BRL" }
    final_advalorem_cents { 0 }
    final_advalorem_currency { "BRL" }
    final_protection_cents { 0 }
    final_protection_currency { "BRL" }
    veredict_at { nil }

    trait :paid_overdue do
      value_cents { 1000000 }
      value_currency { "BRL" }
      initial_fator_cents { 42433 }
      initial_fator_currency { "BRL" }
      initial_advalorem_cents { 1132 }
      initial_advalorem_currency { "BRL" }
      initial_protection_cents { 0 }
      initial_protection_currency { "BRL" }
      due_date { "2019-09-22" }
      ordered_at { "2019-08-22 19:25:21" }
      deposited_at { "2019-08-22 20:25:21" }
      finished_at { "2019-09-26 14:25:21" }
      backoffice_status { "deposited" }
      liquidation_status { "paid" }
      unavailability { "unavailability_non_applicable" }
      rejection_motive { "rejection_motive_non_applicable" }
      final_fator_cents { 43654 }
      final_fator_currency { "BRL" }
      final_advalorem_cents { 1165 }
      final_advalorem_currency { "BRL" }
      final_protection_cents { 0 }
      final_protection_currency { "BRL" }
      veredict_at { "2019-08-22 20:15:21" }
    end

    trait :paid do
      value_cents { 1000000 }
      value_currency { "BRL" }
      initial_fator_cents { 42433 }
      initial_fator_currency { "BRL" }
      initial_advalorem_cents { 1132 }
      initial_advalorem_currency { "BRL" }
      initial_protection_cents { 0 }
      initial_protection_currency { "BRL" }
      due_date { "2019-09-23" }
      ordered_at { "2019-08-23 19:25:21" }
      deposited_at { "2019-08-23 20:25:21" }
      finished_at { "2019-09-26 14:25:21" }
      backoffice_status { "deposited" }
      liquidation_status { "paid" }
      unavailability { "unavailability_non_applicable" }
      rejection_motive { "rejection_motive_non_applicable" }
      final_fator_cents { 42433 }
      final_fator_currency { "BRL" }
      final_advalorem_cents { 1132 }
      final_advalorem_currency { "BRL" }
      final_protection_cents { 0 }
      final_protection_currency { "BRL" }
      veredict_at { "2019-08-23 20:15:21" }
    end

    trait :paid_ahead do
      value_cents { 1000000 }
      value_currency { "BRL" }
      initial_fator_cents { 42433 }
      initial_fator_currency { "BRL" }
      initial_advalorem_cents { 1132 }
      initial_advalorem_currency { "BRL" }
      initial_protection_cents { 0 }
      initial_protection_currency { "BRL" }
      due_date { "2019-09-27" }
      ordered_at { "2019-08-27 19:25:21" }
      deposited_at { "2019-08-27 20:25:21" }
      finished_at { "2019-09-26 14:25:21" }
      backoffice_status { "deposited" }
      liquidation_status { "paid" }
      unavailability { "unavailability_non_applicable" }
      rejection_motive { "rejection_motive_non_applicable" }
      final_fator_cents { 37536 }
      final_fator_currency { "BRL" }
      final_advalorem_cents { 999 }
      final_advalorem_currency { "BRL" }
      final_protection_cents { 0 }
      final_protection_currency { "BRL" }
      veredict_at { "2019-08-27 20:15:21" }
    end

  end
end
