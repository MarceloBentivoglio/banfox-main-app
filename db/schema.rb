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

ActiveRecord::Schema.define(version: 2018_05_17_164743) do

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

  create_table "installments", force: :cascade do |t|
    t.string "number"
    t.bigint "value_cents", default: 0, null: false
    t.string "value_currency", default: "BRL", null: false
    t.date "due_date"
    t.date "receipt_date"
    t.integer "liquidation_status", default: 0
    t.string "import_ref"
    t.bigint "invoice_id"
    t.bigint "rebuy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_installments_on_invoice_id"
    t.index ["rebuy_id"], name: "index_installments_on_rebuy_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "invoice_type"
    t.string "number"
    t.date "sale_date"
    t.date "deposit_date"
    t.integer "backoffice_status", default: 0
    t.string "import_ref"
    t.bigint "seller_id"
    t.bigint "payer_id"
    t.bigint "operation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operation_id"], name: "index_invoices_on_operation_id"
    t.index ["payer_id"], name: "index_invoices_on_payer_id"
    t.index ["seller_id"], name: "index_invoices_on_seller_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "import_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rebuys", force: :cascade do |t|
    t.string "import_ref"
    t.bigint "operation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["operation_id"], name: "index_rebuys_on_operation_id"
  end

  create_table "sellers", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
    t.string "birth_date"
    t.string "phone"
    t.string "company_name"
    t.string "company_nickname"
    t.string "cnpj"
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
    t.bigint "operation_limit_cents", default: 0, null: false
    t.string "operation_limit_currency", default: "BRL", null: false
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
    t.string "birth_date_partner"
    t.string "mobile"
    t.string "mobile_partner"
    t.string "email_partner"
    t.boolean "consent"
    t.integer "validation_status"
    t.integer "analysis_status", default: 0
    t.boolean "visited", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["seller_id"], name: "index_users_on_seller_id"
  end

  add_foreign_key "installments", "invoices"
  add_foreign_key "installments", "rebuys"
  add_foreign_key "invoices", "operations"
  add_foreign_key "invoices", "payers"
  add_foreign_key "invoices", "sellers"
  add_foreign_key "rebuys", "operations"
  add_foreign_key "users", "sellers"
end
