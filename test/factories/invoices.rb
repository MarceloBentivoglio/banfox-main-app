FactoryBot.define do
  factory :invoice do
    invoice_type { "merchandise" }
    number { "980" }
    import_ref { nil }
    created_at { "2019-07-16 19:24:54" }
    updated_at { "2019-07-16 19:24:54" }
    issue_date { nil }
    doc_parser_ref { nil }
    doc_parser_ticket { nil }
    doc_parser_data { nil }
  end
end
