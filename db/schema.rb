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

ActiveRecord::Schema.define(version: 2019_10_04_083629) do

  create_table "books", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.string "author"
    t.string "publisher"
    t.text "intro"
    t.string "isbn", null: false
    t.string "cover"
    t.string "douban_id"
    t.integer "creator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_books_on_creator_id"
    t.index ["isbn"], name: "index_books_on_isbn", unique: true
  end

  create_table "deals", force: :cascade do |t|
    t.string "type"
    t.integer "print_book_id", null: false
    t.integer "book_id", null: false
    t.integer "sponsor_id", null: false
    t.integer "receiver_id"
    t.string "location"
    t.integer "status", default: 0
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer "applicant_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["applicant_id"], name: "index_deals_on_applicant_id"
    t.index ["book_id"], name: "index_deals_on_book_id"
    t.index ["print_book_id"], name: "index_deals_on_print_book_id"
    t.index ["receiver_id"], name: "index_deals_on_receiver_id"
    t.index ["sponsor_id"], name: "index_deals_on_sponsor_id"
  end

  create_table "identities", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "print_books", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "owner_id", null: false
    t.integer "holder_id", null: false
    t.integer "property", default: 0
    t.integer "status", default: 0
    t.text "images"
    t.text "description"
    t.integer "creator_id", null: false
    t.integer "last_deal_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_print_books_on_book_id"
    t.index ["creator_id"], name: "index_print_books_on_creator_id"
    t.index ["holder_id"], name: "index_print_books_on_holder_id"
    t.index ["owner_id"], name: "index_print_books_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username"
    t.string "nickname"
    t.string "avatar"
    t.integer "gender"
    t.string "country"
    t.string "province"
    t.string "city"
    t.integer "language"
    t.string "phone"
    t.string "company"
    t.text "bio"
    t.string "contact"
    t.datetime "birthdate"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "books", "users", column: "creator_id"
  add_foreign_key "deals", "books"
  add_foreign_key "deals", "print_books"
  add_foreign_key "deals", "users", column: "applicant_id"
  add_foreign_key "deals", "users", column: "receiver_id"
  add_foreign_key "deals", "users", column: "sponsor_id"
  add_foreign_key "identities", "users"
  add_foreign_key "print_books", "books"
  add_foreign_key "print_books", "users", column: "creator_id"
  add_foreign_key "print_books", "users", column: "holder_id"
  add_foreign_key "print_books", "users", column: "owner_id"
end
