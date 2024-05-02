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

ActiveRecord::Schema[7.1].define(version: 2024_05_02_071111) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uidLine"
  end

  create_table "queue_users", force: :cascade do |t|
    t.string "cusName"
    t.string "cusPhone"
    t.string "cusSeat"
    t.string "cusStatus"
    t.string "cusTimeEnd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.index ["customer_id"], name: "index_queue_users_on_customer_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.string "tokenLineID"
    t.string "tokenAdmin"
    t.string "expiredLine"
    t.string "expiredAdmin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_id"
    t.bigint "admins_id"
    t.index ["admins_id"], name: "index_tokens_on_admins_id"
    t.index ["customer_id"], name: "index_tokens_on_customer_id"
  end

  add_foreign_key "queue_users", "customers"
  add_foreign_key "tokens", "admins", column: "admins_id"
  add_foreign_key "tokens", "customers"
end
