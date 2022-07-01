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

ActiveRecord::Schema.define(version: 2022_07_01_161631) do

  create_table "claims", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "reward_id", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reward_id"], name: "index_claims_on_reward_id"
    t.index ["user_id"], name: "index_claims_on_user_id"
  end

  create_table "points_archives", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "year"
    t.integer "total"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_points_archives_on_user_id"
  end

  create_table "points_records", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "transaction_id"
    t.integer "amount", default: 0
    t.text "description"
    t.string "action", default: "credit"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["transaction_id"], name: "index_points_records_on_transaction_id"
    t.index ["user_id"], name: "index_points_records_on_user_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "currency"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.date "birthdate"
    t.integer "points_cached", default: 0
    t.string "tier", default: "standard"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "claims", "rewards"
  add_foreign_key "claims", "users"
  add_foreign_key "points_archives", "users"
  add_foreign_key "points_records", "transactions"
  add_foreign_key "points_records", "users"
  add_foreign_key "transactions", "users"
end
