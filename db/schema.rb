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

ActiveRecord::Schema.define(version: 20180517132646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "installments", force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "number"
    t.integer "value_cents", default: 0, null: false
    t.string "value_currency", default: "USD", null: false
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_installments_on_invoice_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "invoice_type"
    t.string "number"
    t.bigint "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payer_id"
    t.index ["payer_id"], name: "index_invoices_on_payer_id"
    t.index ["seller_id"], name: "index_invoices_on_seller_id"
  end

  create_table "payers", force: :cascade do |t|
    t.string "cnpj"
    t.string "company_name"
    t.string "company_nickname"
    t.string "business_entity"
    t.string "registration_number"
    t.string "nire"
    t.datetime "incorporation_date"
    t.string "zip_code"
    t.string "address"
    t.string "address_number"
    t.string "neighborhood"
    t.string "address_2"
    t.string "state"
    t.string "city"
    t.string "corporate_capital"
    t.string "activity"
    t.string "cnae"
    t.string "tax_option"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sellers", force: :cascade do |t|
    t.string "full_name"
    t.string "cpf"
    t.string "phone"
    t.string "company_name"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "product_manufacture", default: false
    t.boolean "service_provision", default: false
    t.boolean "product_reselling", default: false
    t.integer "company_type"
    t.integer "revenue"
    t.integer "rental_cost"
    t.integer "employees"
    t.boolean "generate_boleto", default: false
    t.boolean "generate_invoice", default: false
    t.boolean "receive_cheque", default: false
    t.boolean "receive_money_transfer", default: false
    t.boolean "company_clients", default: false
    t.boolean "individual_clients", default: false
    t.boolean "government_clients", default: false
    t.boolean "pay_up_front", default: false
    t.boolean "pay_30_60_90", default: false
    t.boolean "pay_90_plus", default: false
    t.boolean "pay_factoring", default: false
    t.boolean "permit_contact_client", default: false
    t.boolean "charge_payer", default: false
    t.boolean "consent", default: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seller_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["seller_id"], name: "index_users_on_seller_id"
  end

  add_foreign_key "installments", "invoices"
  add_foreign_key "invoices", "payers"
  add_foreign_key "users", "sellers"
end
