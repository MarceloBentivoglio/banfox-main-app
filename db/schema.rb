# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_29_234733) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "analyzed_parts", force: :cascade do |t|
    t.bigint "key_indicator_report_id"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key_indicator_report_id"], name: "index_analyzed_parts_on_key_indicator_report_id"
  end

  create_table "balances", force: :cascade do |t|
    t.bigint "installment_id"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "value_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.bigint "operation_id"
    t.index ["installment_id"], name: "index_balances_on_installment_id"
    t.index ["operation_id"], name: "index_balances_on_operation_id"
    t.index ["seller_id"], name: "index_balances_on_seller_id"
  end

  create_table "evidences", force: :cascade do |t|
    t.jsonb "input_data"
    t.jsonb "collected_data"
    t.string "referee_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "external_data", force: :cascade do |t|
    t.string "source"
    t.jsonb "raw_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "query"
    t.datetime "ttl"
  end

  create_table "external_data_key_indicator_reports", id: false, force: :cascade do |t|
    t.integer "external_datum_id"
    t.integer "key_indicator_report_id"
    t.index ["external_datum_id", "key_indicator_report_id"], name: "external_data_key_indicator_report"
  end

  create_table "installments", force: :cascade do |t|
    t.string "number"
    t.bigint "value_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.bigint "initial_fator_cents", default: 0, null: false
    t.string "initial_fator_currency", default: "BRL", null: false
    t.bigint "initial_advalorem_cents", default: 0, null: false
    t.string "initial_advalorem_currency", default: "BRL", null: false
    t.bigint "initial_protection_cents", default: 0, null: false
    t.string "initial_protection_currency", default: "BRL", null: false
    t.date "due_date"
    t.datetime "ordered_at"
    t.datetime "deposited_at"
    t.datetime "finished_at"
    t.integer "backoffice_status", default: 0
    t.integer "liquidation_status", default: 0
    t.integer "unavailability", default: 0
    t.integer "rejection_motive", default: 0
    t.string "import_ref"
    t.bigint "invoice_id"
    t.bigint "operation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "final_fator_cents", default: 0, null: false
    t.string "final_fator_currency", default: "BRL", null: false
    t.bigint "final_advalorem_cents", default: 0, null: false
    t.string "final_advalorem_currency", default: "BRL", null: false
    t.bigint "final_protection_cents", default: 0, null: false
    t.string "final_protection_currency", default: "BRL", null: false
    t.datetime "veredict_at"
    t.index ["invoice_id"], name: "index_installments_on_invoice_id"
    t.index ["operation_id"], name: "index_installments_on_operation_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "invoice_type", default: 0
    t.string "number"
    t.string "import_ref"
    t.bigint "seller_id"
    t.bigint "payer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "issued_at"
    t.string "doc_parser_ref"
    t.jsonb "doc_parser_ticket"
    t.jsonb "doc_parser_data"
    t.string "nfe_key"
    t.index ["payer_id"], name: "index_invoices_on_payer_id"
    t.index ["seller_id"], name: "index_invoices_on_seller_id"
  end

  create_table "invoices_documents_bundles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "joint_debtors", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.string "mobile"
    t.string "documentation"
    t.string "email"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["seller_id"], name: "index_joint_debtors_on_seller_id"
  end

  create_table "key_indicator_reports", force: :cascade do |t|
    t.jsonb "input_data"
    t.string "pipeline"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "ttl"
    t.string "kind"
    t.jsonb "evidences", default: {}
    t.bigint "operation_id"
    t.jsonb "key_indicators", default: {}
    t.boolean "processed", default: false
  end

  create_table "key_indicators", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.string "description"
    t.integer "flag"
    t.integer "scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "params"
  end

  create_table "operations", force: :cascade do |t|
    t.boolean "consent", default: false, null: false
    t.string "import_ref"
    t.boolean "signed", default: false
    t.jsonb "sign_document_info"
    t.string "sign_document_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sign_document_requested_at"
    t.datetime "signed_at"
    t.integer "sign_documents_provider"
    t.integer "sign_document_status", default: 0
    t.boolean "sign_document_error", default: false
    t.bigint "used_balance_cents", default: 0, null: false
    t.string "used_balance_currency", default: "BRL", null: false
  end

  create_table "payers", force: :cascade do |t|
    t.string "company_name"
    t.string "cnpj"
    t.string "inscr_est"
    t.string "inscr_mun"
    t.string "nire"
    t.integer "company_type"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "address_number"
    t.string "address_comp"
    t.string "neighborhood"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "import_ref"
    t.decimal "fator"
    t.decimal "advalorem"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
    t.string "rf_full_name"
    t.string "rf_sit_cad"
    t.string "birth_date"
    t.string "mobile"
    t.string "company_name"
    t.string "company_nickname"
    t.string "cnpj"
    t.string "phone"
    t.string "website"
    t.string "address"
    t.string "address_number"
    t.string "address_comp"
    t.string "neighborhood"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "inscr_est"
    t.string "inscr_mun"
    t.string "nire"
    t.integer "company_type"
    t.bigint "monthly_revenue_cents", default: 0, null: false
    t.string "monthly_revenue_currency", default: "BRL", null: false
    t.bigint "monthly_fixed_cost_cents", default: 0, null: false
    t.string "monthly_fixed_cost_currency", default: "BRL", null: false
    t.bigint "monthly_units_sold"
    t.bigint "cost_per_unit_cents", default: 0, null: false
    t.string "cost_per_unit_currency", default: "BRL", null: false
    t.bigint "debt_cents", default: 0, null: false
    t.string "debt_currency", default: "BRL", null: false
    t.string "full_name_partner"
    t.string "cpf_partner"
    t.string "rf_full_name_partner"
    t.string "rf_sit_cad_partner"
    t.string "birth_date_partner"
    t.string "mobile_partner"
    t.string "email_partner"
    t.boolean "consent"
    t.decimal "fator"
    t.decimal "advalorem"
    t.decimal "protection"
    t.bigint "operation_limit_cents", default: 0, null: false
    t.string "operation_limit_currency", default: "BRL", null: false
    t.integer "validation_status"
    t.boolean "visited", default: false, null: false
    t.integer "analysis_status", default: 0
    t.integer "rejection_motive", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tax_regime"
    t.datetime "auto_veredict_at"
    t.datetime "veredict_at"
    t.boolean "allowed_to_operate"
    t.datetime "forbad_to_operate_at"
    t.integer "sign_documents_provider"
    t.string "digital_certificate_password"
    t.text "digital_certificate_base64"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.boolean "admin", default: false, null: false
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["seller_id"], name: "index_users_on_seller_id"
  end

  add_foreign_key "analyzed_parts", "key_indicator_reports"
  add_foreign_key "balances", "operations"
  add_foreign_key "installments", "invoices"
  add_foreign_key "installments", "operations"
  add_foreign_key "invoices", "payers"
  add_foreign_key "invoices", "sellers"
  add_foreign_key "joint_debtors", "sellers"
  add_foreign_key "users", "sellers"
end
