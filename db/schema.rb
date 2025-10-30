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

ActiveRecord::Schema[8.1].define(version: 2021_06_28_184754) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "notes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "markdown"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "bids"
    t.string "category", limit: 50
    t.datetime "created_at", null: false
    t.string "hand", limit: 16
    t.text "note"
    t.integer "points", limit: 2
    t.string "shape", limit: 10
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "vul", limit: 4
    t.index ["user_id"], name: "index_problems_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "attempts", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "due", precision: nil
    t.decimal "factor", precision: 3, scale: 2, default: "2.5"
    t.integer "interval", limit: 2, default: 0
    t.bigint "problem_id"
    t.integer "repetitions", limit: 2, default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["problem_id"], name: "index_reviews_on_problem_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "users"
end
