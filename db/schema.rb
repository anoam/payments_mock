# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_16_153906) do

  create_table "domain_merchant_transactions", force: :cascade do |t|
    t.string "uuid", null: false
    t.decimal "amount"
    t.integer "status", default: 0, null: false
    t.integer "merchant_id", null: false
    t.integer "base_transaction_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["base_transaction_id"], name: "index_domain_merchant_transactions_on_base_transaction_id"
    t.index ["merchant_id"], name: "index_domain_merchant_transactions_on_merchant_id"
    t.index ["uuid"], name: "index_domain_merchant_transactions_on_uuid", unique: true
  end

  create_table "domain_merchants", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.decimal "transaction_sum"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_domain_merchants_on_email", unique: true
  end

  create_table "user_management_users", force: :cascade do |t|
    t.string "type"
    t.string "email"
    t.string "encrypted_password"
    t.string "token"
    t.integer "domain_merchant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_user_management_users_on_token", unique: true
  end

  add_foreign_key "domain_merchant_transactions", "domain_merchants", column: "merchant_id"
  add_foreign_key "user_management_users", "domain_merchants"
end
