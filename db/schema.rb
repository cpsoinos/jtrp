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

ActiveRecord::Schema.define(version: 20161203225938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "account_number"
    t.boolean  "is_company",         default: false
    t.string   "company_name"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
    t.integer  "primary_contact_id"
    t.string   "status",             default: "potential",     null: false
    t.integer  "jobs_count"
    t.string   "type",               default: "ClientAccount", null: false
    t.string   "slug"
    t.datetime "deleted_at"
  end

  add_index "accounts", ["deleted_at"], name: "index_accounts_on_deleted_at", using: :btree
  add_index "accounts", ["primary_contact_id"], name: "index_accounts_on_primary_contact_id", using: :btree
  add_index "accounts", ["slug"], name: "index_accounts_on_slug", using: :btree

  create_table "agreements", force: :cascade do |t|
    t.integer  "proposal_id"
    t.string   "agreement_type",                          null: false
    t.string   "status"
    t.datetime "date"
    t.integer  "check_number"
    t.boolean  "client_agreed"
    t.boolean  "manager_agreed"
    t.datetime "manager_agreed_at"
    t.datetime "client_agreed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "service_charge_cents",    default: 0,     null: false
    t.string   "service_charge_currency", default: "USD", null: false
    t.string   "token",                                   null: false
    t.datetime "deleted_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  add_index "agreements", ["deleted_at"], name: "index_agreements_on_deleted_at", using: :btree
  add_index "agreements", ["proposal_id"], name: "index_agreements_on_proposal_id", using: :btree

  create_table "archives", force: :cascade do |t|
    t.string "archive"
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         default: 0
    t.string   "comment"
    t.string   "remote_address"
    t.string   "request_uuid"
    t.datetime "created_at"
  end

  add_index "audits", ["associated_id", "associated_type"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_id", "auditable_type"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

  create_table "bootsy_image_galleries", force: :cascade do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: :cascade do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.string   "photo"
    t.string   "slug"
    t.datetime "deleted_at"
  end

  add_index "categories", ["deleted_at"], name: "index_categories_on_deleted_at", using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", using: :btree

  create_table "checks", force: :cascade do |t|
    t.integer  "statement_id"
    t.string   "remote_id"
    t.string   "remote_url"
    t.integer  "amount_cents",           default: 0,     null: false
    t.string   "amount_currency",        default: "USD", null: false
    t.integer  "check_number"
    t.string   "carrier"
    t.string   "tracking_number"
    t.string   "expected_delivery_date"
    t.jsonb    "data"
    t.string   "check_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "checks", ["statement_id"], name: "index_checks_on_statement_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",                        null: false
    t.string   "slogan"
    t.text     "description"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.string   "phone_ext"
    t.string   "website"
    t.string   "logo"
    t.text     "consignment_policies"
    t.text     "service_rate_schedule"
    t.text     "agent_service_rate_schedule"
    t.string   "email"
    t.integer  "primary_contact_id"
    t.string   "slug"
    t.string   "team_email"
    t.string   "meta_description"
    t.string   "facebook_page"
    t.string   "twitter_account"
    t.string   "instagram_account"
    t.string   "google_plus_account"
    t.string   "linkedin_account"
    t.string   "yelp_account"
    t.string   "houzz_account"
    t.string   "pinterest_account"
    t.datetime "deleted_at"
  end

  add_index "companies", ["deleted_at"], name: "index_companies_on_deleted_at", using: :btree
  add_index "companies", ["primary_contact_id"], name: "index_companies_on_primary_contact_id", using: :btree
  add_index "companies", ["slug"], name: "index_companies_on_slug", using: :btree

  create_table "discounts", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount_cents"
    t.string   "amount_currency", default: "USD", null: false
    t.string   "name"
    t.string   "remote_id"
    t.boolean  "applied",         default: false
    t.decimal  "percentage"
    t.datetime "deleted_at"
  end

  add_index "discounts", ["deleted_at"], name: "index_discounts_on_deleted_at", using: :btree
  add_index "discounts", ["item_id"], name: "index_discounts_on_item_id", using: :btree
  add_index "discounts", ["order_id"], name: "index_discounts_on_order_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "gift_certificates", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.integer  "initial_balance_cents"
    t.string   "initial_balance_currency", default: "USD",           null: false
    t.integer  "current_balance_cents"
    t.string   "current_balance_currency", default: "USD",           null: false
    t.integer  "order_id"
    t.string   "remote_id",                default: "14QFV6H0K3N62"
  end

  create_table "item_spreadsheets", force: :cascade do |t|
    t.string "csv"
  end

  create_table "items", force: :cascade do |t|
    t.text     "description",                                       null: false
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "condition"
    t.integer  "purchase_price_cents"
    t.string   "purchase_price_currency",     default: "USD",       null: false
    t.integer  "listing_price_cents"
    t.string   "listing_price_currency",      default: "USD",       null: false
    t.integer  "sale_price_cents"
    t.string   "sale_price_currency",         default: "USD",       null: false
    t.string   "token"
    t.integer  "proposal_id"
    t.string   "status",                      default: "potential", null: false
    t.integer  "minimum_sale_price_cents"
    t.string   "minimum_sale_price_currency", default: "USD",       null: false
    t.string   "client_intention",            default: "undecided", null: false
    t.text     "notes"
    t.boolean  "will_purchase"
    t.boolean  "will_consign"
    t.integer  "account_item_number"
    t.decimal  "consignment_rate",            default: 50.0
    t.datetime "listed_at"
    t.datetime "sold_at"
    t.string   "remote_id"
    t.integer  "order_id"
    t.boolean  "import",                      default: false
    t.string   "initial_description"
    t.integer  "parent_item_id"
    t.integer  "jtrp_number"
    t.string   "original_description"
    t.string   "slug"
    t.datetime "deleted_at"
    t.boolean  "expired",                     default: false
    t.integer  "consignment_term",            default: 90
  end

  add_index "items", ["account_item_number"], name: "index_items_on_account_item_number", using: :btree
  add_index "items", ["category_id"], name: "index_items_on_category_id", using: :btree
  add_index "items", ["client_intention"], name: "index_items_on_client_intention", using: :btree
  add_index "items", ["deleted_at"], name: "index_items_on_deleted_at", using: :btree
  add_index "items", ["order_id"], name: "index_items_on_order_id", using: :btree
  add_index "items", ["proposal_id"], name: "index_items_on_proposal_id", using: :btree
  add_index "items", ["slug"], name: "index_items_on_slug", using: :btree
  add_index "items", ["status", "account_item_number", "jtrp_number"], name: "index_items_on_status_and_account_item_number_and_jtrp_number", using: :btree
  add_index "items", ["status", "account_item_number"], name: "index_items_on_status_and_account_item_number", using: :btree
  add_index "items", ["status", "client_intention"], name: "index_items_on_status_and_client_intention", using: :btree
  add_index "items", ["status", "jtrp_number"], name: "index_items_on_status_and_jtrp_number", using: :btree
  add_index "items", ["status"], name: "index_items_on_status", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "address_1",                        null: false
    t.string   "address_2"
    t.string   "city",                             null: false
    t.string   "state",                            null: false
    t.string   "zip"
    t.string   "status",     default: "potential", null: false
    t.string   "slug"
    t.datetime "deleted_at"
  end

  add_index "jobs", ["account_id"], name: "index_jobs_on_account_id", using: :btree
  add_index "jobs", ["deleted_at"], name: "index_jobs_on_deleted_at", using: :btree
  add_index "jobs", ["slug"], name: "index_jobs_on_slug", using: :btree

  create_table "letters", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.string   "pdf"
    t.string   "remote_id"
    t.string   "remote_url"
    t.string   "carrier"
    t.string   "tracking_number"
    t.string   "expected_delivery_date"
    t.datetime "deleted_at"
    t.string   "token"
    t.integer  "agreement_id"
  end

  add_index "letters", ["deleted_at"], name: "index_letters_on_deleted_at", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "remote_id"
    t.integer  "amount_cents",    default: 0,     null: false
    t.string   "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "orders", ["deleted_at"], name: "index_orders_on_deleted_at", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "photo"
    t.string   "photo_type",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "proposal_id"
    t.datetime "deleted_at"
  end

  add_index "photos", ["deleted_at"], name: "index_photos_on_deleted_at", using: :btree
  add_index "photos", ["item_id", "photo_type"], name: "index_photos_on_item_id_and_photo_type", using: :btree
  add_index "photos", ["item_id"], name: "index_photos_on_item_id", using: :btree
  add_index "photos", ["photo_type"], name: "index_photos_on_photo_type", using: :btree
  add_index "photos", ["proposal_id"], name: "index_photos_on_proposal_id", using: :btree

  create_table "proposals", force: :cascade do |t|
    t.integer  "created_by_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "job_id",        null: false
    t.integer  "items_count"
    t.string   "token",         null: false
    t.datetime "deleted_at"
  end

  add_index "proposals", ["deleted_at"], name: "index_proposals_on_deleted_at", using: :btree
  add_index "proposals", ["job_id"], name: "index_proposals_on_job_id", using: :btree

  create_table "scanned_agreements", force: :cascade do |t|
    t.integer  "agreement_id", null: false
    t.string   "scan",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "scanned_agreements", ["agreement_id"], name: "index_scanned_agreements_on_agreement_id", using: :btree
  add_index "scanned_agreements", ["deleted_at"], name: "index_scanned_agreements_on_deleted_at", using: :btree

  create_table "statement_pdfs", force: :cascade do |t|
    t.integer  "statement_id"
    t.string   "pdf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "statement_pdfs", ["deleted_at"], name: "index_statement_pdfs_on_deleted_at", using: :btree
  add_index "statement_pdfs", ["statement_id"], name: "index_statement_pdfs_on_statement_id", using: :btree

  create_table "statements", force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "check_number"
    t.string   "status"
    t.string   "token"
    t.integer  "account_id"
    t.datetime "deleted_at"
  end

  add_index "statements", ["account_id"], name: "index_statements_on_account_id", using: :btree
  add_index "statements", ["deleted_at"], name: "index_statements_on_deleted_at", using: :btree

  create_table "system_infos", force: :cascade do |t|
    t.integer "last_account_number", default: 10
  end

  create_table "transactional_email_records", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "recipient_id"
    t.string   "category"
    t.json     "sendgrid_response"
    t.datetime "deleted_at"
  end

  add_index "transactional_email_records", ["deleted_at"], name: "index_transactional_email_records_on_deleted_at", using: :btree

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
    t.string   "role"
    t.string   "first_name",                                     null: false
    t.string   "last_name",                                      null: false
    t.string   "address_1",                                      null: false
    t.string   "address_2"
    t.string   "city",                                           null: false
    t.string   "state",                                          null: false
    t.string   "zip"
    t.string   "phone"
    t.string   "phone_ext"
    t.string   "status",                      default: "active", null: false
    t.boolean  "consignment_policy_accepted", default: false
    t.string   "avatar"
    t.integer  "account_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "clover_token"
    t.string   "slug"
    t.datetime "deleted_at"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  create_table "webhooks", force: :cascade do |t|
    t.string   "integration"
    t.jsonb    "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "agreements", "proposals"
  add_foreign_key "checks", "statements"
  add_foreign_key "discounts", "items"
  add_foreign_key "discounts", "orders"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "orders"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "photos", "items"
  add_foreign_key "photos", "proposals"
  add_foreign_key "scanned_agreements", "agreements"
  add_foreign_key "statement_pdfs", "statements"
  add_foreign_key "statements", "accounts"
  add_foreign_key "users", "accounts"
end
