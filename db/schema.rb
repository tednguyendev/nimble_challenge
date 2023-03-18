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

ActiveRecord::Schema.define(version: 2023_03_18_042852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "keywords", force: :cascade do |t|
    t.string "value"
    t.bigint "user_id"
    t.bigint "report_id"
    t.integer "ad_words_count"
    t.integer "links_count"
    t.bigint "total_results"
    t.decimal "search_time", precision: 14, scale: 4
    t.text "html_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.index ["report_id"], name: "index_keywords_on_report_id"
    t.index ["user_id"], name: "index_keywords_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "name", default: ""
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "percentage", default: 0
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "activated", default: false
  end

  add_foreign_key "keywords", "reports"
  add_foreign_key "keywords", "users"
  add_foreign_key "reports", "users"
end
