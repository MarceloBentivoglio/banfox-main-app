FactoryBot.define do
  factory :operation do
    consent { true }
    import_ref { nil }
    signed { false }
    sign_document_info { nil }
    sign_document_key { nil }
    created_at { "2019-07-16 19:25:21" }
    updated_at { "2019-07-16 19:25:21" }
    sign_document_requested_at { nil }
    signed_at { nil }
  end
end
