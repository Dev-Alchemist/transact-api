# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_04_13_213907) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "type", null: false
    t.jsonb "params"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
  end

  create_table "topups", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "amount"
    t.string "reference"
    t.string "phone_number"
    t.string "status"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_topups_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "sender_balance_before", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "sender_balance_after", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "recipient_balance_before", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "recipient_balance_after", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["recipient_type", "recipient_id"], name: "index_transactions_on_recipient"
    t.index ["sender_id"], name: "index_transactions_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance", precision: 8, scale: 2, default: "0.0"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "topups", "users"
  add_foreign_key "transactions", "users", column: "sender_id"
end
