# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160408125309) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name",        null: false
    t.string "slogan"
    t.string "description"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "phone_ext"
    t.string "website"
    t.string "logo"
  end

  create_table "items", force: :cascade do |t|
    t.text     "description",                                       null: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.json     "initial_photos"
    t.string   "condition"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.integer  "purchase_price_cents"
    t.string   "purchase_price_currency",     default: "USD",       null: false
    t.integer  "listing_price_cents"
    t.string   "listing_price_currency",      default: "USD",       null: false
    t.integer  "sale_price_cents"
    t.string   "sale_price_currency",         default: "USD",       null: false
    t.string   "token"
    t.integer  "proposal_id"
    t.json     "listing_photos"
    t.string   "status",                      default: "potential", null: false
    t.integer  "minimum_sale_price_cents"
    t.string   "minimum_sale_price_currency", default: "USD",       null: false
    t.integer  "purchase_order_id"
    t.string   "name",                                              null: false
    t.integer  "client_id"
    t.string   "client_intention",            default: "undecided"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree
  add_index "items", ["client_id"], name: "index_items_on_client_id", using: :btree
  add_index "items", ["proposal_id"], name: "index_items_on_proposal_id", using: :btree
  add_index "items", ["purchase_order_id"], name: "index_items_on_purchase_order_id", using: :btree

  create_table "proposals", force: :cascade do |t|
    t.integer  "client_id",     null: false
    t.integer  "created_by_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "client_id",     null: false
    t.integer  "created_by_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                       default: "",       null: false
    t.string   "encrypted_password",          default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "role",                        default: "guest"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "phone_ext"
    t.string   "status",                      default: "active", null: false
    t.boolean  "consignment_policy_accepted", default: false
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "items", "categories"
end
