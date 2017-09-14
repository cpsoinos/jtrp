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

ActiveRecord::Schema.define(version: 20170914114606) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.integer "account_number"
    t.boolean "is_company", default: false
    t.string "company_name"
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes"
    t.integer "primary_contact_id"
    t.string "status", default: "potential", null: false
    t.integer "jobs_count"
    t.string "type", default: "ClientAccount", null: false
    t.string "slug"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
    t.index ["primary_contact_id"], name: "index_accounts_on_primary_contact_id"
    t.index ["slug"], name: "index_accounts_on_slug"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "trackable_id"
    t.string "trackable_type"
    t.integer "owner_id"
    t.string "owner_type"
    t.string "key"
    t.text "parameters"
    t.integer "recipient_id"
    t.string "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "agreement_items", force: :cascade do |t|
    t.bigint "agreement_id"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_agreement_items_on_agreement_id"
    t.index ["item_id"], name: "index_agreement_items_on_item_id"
  end

  create_table "agreements", id: :serial, force: :cascade do |t|
    t.integer "proposal_id"
    t.string "agreement_type", null: false
    t.string "status"
    t.datetime "date"
    t.string "check_number"
    t.boolean "client_agreed"
    t.boolean "manager_agreed"
    t.datetime "manager_agreed_at"
    t.datetime "client_agreed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "service_charge_cents", default: 0, null: false
    t.string "service_charge_currency", default: "USD", null: false
    t.string "token", null: false
    t.datetime "deleted_at"
    t.integer "created_by_id"
    t.integer "updated_by_id"
    t.string "pdf"
    t.integer "pdf_pages"
    t.index ["deleted_at"], name: "index_agreements_on_deleted_at"
    t.index ["proposal_id"], name: "index_agreements_on_proposal_id"
  end

  create_table "ahoy_messages", id: :serial, force: :cascade do |t|
    t.string "token"
    t.text "to"
    t.integer "user_id"
    t.string "user_type"
    t.string "mailer"
    t.text "subject"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
    t.index ["token"], name: "index_ahoy_messages_on_token"
    t.index ["user_id", "user_type"], name: "index_ahoy_messages_on_user_id_and_user_type"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "bootsy_image_galleries", id: :serial, force: :cascade do |t|
    t.integer "bootsy_resource_id"
    t.string "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", id: :serial, force: :cascade do |t|
    t.string "image_file"
    t.integer "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "parent_id"
    t.string "photo"
    t.string "slug"
    t.datetime "deleted_at"
    t.integer "subcategories_count", default: 0
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["slug"], name: "index_categories_on_slug"
  end

  create_table "checks", id: :serial, force: :cascade do |t|
    t.integer "statement_id"
    t.string "remote_id"
    t.string "remote_url"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.string "check_number"
    t.string "carrier"
    t.string "tracking_number"
    t.string "expected_delivery_date"
    t.jsonb "data"
    t.string "check_image_front"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string "check_image_back"
    t.index ["statement_id"], name: "index_checks_on_statement_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "slogan"
    t.text "description"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "phone_ext"
    t.string "website"
    t.string "logo"
    t.text "consignment_policies"
    t.text "service_rate_schedule"
    t.text "agent_service_rate_schedule"
    t.string "email"
    t.integer "primary_contact_id"
    t.string "slug"
    t.string "team_email"
    t.string "meta_description"
    t.string "facebook_page"
    t.string "twitter_account"
    t.string "instagram_account"
    t.string "google_plus_account"
    t.string "linkedin_account"
    t.string "yelp_account"
    t.string "houzz_account"
    t.string "pinterest_account"
    t.datetime "deleted_at"
    t.jsonb "hours_of_operation"
    t.string "medium_account"
    t.index ["deleted_at"], name: "index_companies_on_deleted_at"
    t.index ["primary_contact_id"], name: "index_companies_on_primary_contact_id"
    t.index ["slug"], name: "index_companies_on_slug"
  end

  create_table "customers", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "remote_id"
    t.boolean "marketing_allowed"
    t.datetime "customer_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  create_table "discounts", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "amount_cents"
    t.string "amount_currency", default: "USD", null: false
    t.string "name"
    t.string "remote_id"
    t.boolean "applied", default: false
    t.decimal "percentage"
    t.datetime "deleted_at"
    t.integer "discountable_id"
    t.string "discountable_type"
    t.index ["deleted_at"], name: "index_discounts_on_deleted_at"
    t.index ["discountable_type", "discountable_id"], name: "index_discounts_on_discountable_type_and_discountable_id"
    t.index ["item_id"], name: "index_discounts_on_item_id"
    t.index ["order_id"], name: "index_discounts_on_order_id"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.text "description", null: false
    t.integer "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "condition"
    t.integer "purchase_price_cents"
    t.string "purchase_price_currency", default: "USD", null: false
    t.integer "listing_price_cents"
    t.string "listing_price_currency", default: "USD", null: false
    t.integer "sale_price_cents"
    t.string "sale_price_currency", default: "USD", null: false
    t.string "token"
    t.integer "proposal_id"
    t.string "status", default: "potential", null: false
    t.integer "minimum_sale_price_cents"
    t.string "minimum_sale_price_currency", default: "USD", null: false
    t.string "client_intention", default: "undecided", null: false
    t.text "notes"
    t.boolean "will_purchase"
    t.boolean "will_consign"
    t.integer "account_item_number"
    t.decimal "consignment_rate", default: "50.0"
    t.datetime "listed_at"
    t.datetime "sold_at"
    t.string "remote_id"
    t.integer "order_id"
    t.boolean "import", default: false
    t.string "initial_description"
    t.integer "parent_item_id"
    t.integer "jtrp_number"
    t.string "original_description"
    t.string "slug"
    t.datetime "deleted_at"
    t.boolean "expired", default: false
    t.integer "consignment_term", default: 90
    t.integer "parts_cost_cents"
    t.string "parts_cost_currency", default: "USD", null: false
    t.integer "labor_cost_cents"
    t.string "labor_cost_currency", default: "USD", null: false
    t.datetime "acquired_at"
    t.index ["account_item_number"], name: "index_items_on_account_item_number"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["client_intention"], name: "index_items_on_client_intention"
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
    t.index ["order_id"], name: "index_items_on_order_id"
    t.index ["proposal_id"], name: "index_items_on_proposal_id"
    t.index ["slug"], name: "index_items_on_slug"
    t.index ["status", "account_item_number", "jtrp_number"], name: "index_items_on_status_and_account_item_number_and_jtrp_number"
    t.index ["status", "account_item_number"], name: "index_items_on_status_and_account_item_number"
    t.index ["status", "client_intention"], name: "index_items_on_status_and_client_intention"
    t.index ["status", "jtrp_number"], name: "index_items_on_status_and_jtrp_number"
    t.index ["status"], name: "index_items_on_status"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.integer "account_id"
    t.string "address_1", null: false
    t.string "address_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip"
    t.string "status", default: "potential", null: false
    t.string "slug"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_jobs_on_account_id"
    t.index ["deleted_at"], name: "index_jobs_on_deleted_at"
    t.index ["slug"], name: "index_jobs_on_slug"
  end

  create_table "letters", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "category"
    t.string "pdf"
    t.string "remote_id"
    t.string "remote_url"
    t.string "carrier"
    t.string "tracking_number"
    t.string "expected_delivery_date"
    t.datetime "deleted_at"
    t.string "token"
    t.integer "agreement_id"
    t.text "note"
    t.string "letter_pdf"
    t.integer "pdf_pages"
    t.index ["deleted_at"], name: "index_letters_on_deleted_at"
  end

  create_table "oauth_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "image"
    t.string "profile_url"
    t.string "access_token"
    t.jsonb "raw_data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_oauth_accounts_on_user_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.string "remote_id"
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean "processed"
    t.integer "delivery_charge_cents"
    t.string "delivery_charge_currency", default: "USD", null: false
    t.index ["deleted_at"], name: "index_orders_on_deleted_at"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "order_id"
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_cents"
    t.string "amount_currency", default: "USD", null: false
    t.integer "tax_amount_cents"
    t.string "tax_amount_currency", default: "USD", null: false
    t.datetime "deleted_at"
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "searchable_id"
    t.string "searchable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.string "photo"
    t.string "photo_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "proposal_id"
    t.datetime "deleted_at"
    t.integer "position"
    t.index ["deleted_at"], name: "index_photos_on_deleted_at"
    t.index ["item_id", "photo_type"], name: "index_photos_on_item_id_and_photo_type"
    t.index ["item_id"], name: "index_photos_on_item_id"
    t.index ["photo_type"], name: "index_photos_on_photo_type"
    t.index ["proposal_id"], name: "index_photos_on_proposal_id"
  end

  create_table "proposals", id: :serial, force: :cascade do |t|
    t.integer "created_by_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "status"
    t.integer "job_id", null: false
    t.integer "items_count"
    t.string "token", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_proposals_on_deleted_at"
    t.index ["job_id"], name: "index_proposals_on_job_id"
  end

  create_table "statement_items", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.integer "statement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["item_id"], name: "index_statement_items_on_item_id"
    t.index ["statement_id"], name: "index_statement_items_on_statement_id"
  end

  create_table "statement_pdfs", id: :serial, force: :cascade do |t|
    t.integer "statement_id"
    t.string "pdf"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_statement_pdfs_on_deleted_at"
    t.index ["statement_id"], name: "index_statement_pdfs_on_statement_id"
  end

  create_table "statements", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "check_number"
    t.string "status"
    t.string "token"
    t.integer "account_id"
    t.datetime "deleted_at"
    t.string "pdf"
    t.integer "pdf_pages"
    t.index ["account_id"], name: "index_statements_on_account_id"
    t.index ["deleted_at"], name: "index_statements_on_deleted_at"
  end

  create_table "system_infos", id: :serial, force: :cascade do |t|
    t.integer "last_account_number", default: 10
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "transactional_email_records", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "created_by_id"
    t.integer "recipient_id"
    t.string "category"
    t.json "sendgrid_response"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_transactional_email_records_on_deleted_at"
  end

  create_table "users", id: :serial, force: :cascade do |t|
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
    t.string "role"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "address_1", null: false
    t.string "address_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip"
    t.string "phone"
    t.string "phone_ext"
    t.string "status", default: "active", null: false
    t.boolean "consignment_policy_accepted", default: false
    t.string "avatar"
    t.integer "account_id"
    t.string "provider"
    t.string "uid"
    t.string "clover_token"
    t.string "slug"
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug"
  end

  create_table "webhook_entries", id: :serial, force: :cascade do |t|
    t.integer "webhook_id"
    t.integer "webhookable_id"
    t.string "webhookable_type"
    t.datetime "timestamp"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "processed", default: false, null: false
    t.index ["webhook_id"], name: "index_webhook_entries_on_webhook_id"
    t.index ["webhookable_type", "webhookable_id"], name: "index_webhook_entries_on_webhookable_type_and_webhookable_id"
  end

  create_table "webhooks", id: :serial, force: :cascade do |t|
    t.string "integration"
    t.jsonb "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "agreement_items", "agreements"
  add_foreign_key "agreement_items", "items"
  add_foreign_key "agreements", "proposals"
  add_foreign_key "checks", "statements"
  add_foreign_key "discounts", "items"
  add_foreign_key "discounts", "orders"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "orders"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "oauth_accounts", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "photos", "items"
  add_foreign_key "photos", "proposals"
  add_foreign_key "statement_items", "items"
  add_foreign_key "statement_items", "statements"
  add_foreign_key "statement_pdfs", "statements"
  add_foreign_key "statements", "accounts"
  add_foreign_key "users", "accounts"
  add_foreign_key "webhook_entries", "webhooks"
end
