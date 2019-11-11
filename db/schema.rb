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

ActiveRecord::Schema.define(version: 20191111000122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_requests", force: :cascade do |t|
    t.boolean "is_check"
    t.boolean "is_cash"
    t.string "request_by"
    t.string "department"
    t.string "amount_requested"
    t.string "stock_number"
    t.string "make"
    t.string "model"
    t.text "payable_to"
    t.text "description"
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "request_date"
    t.index ["dealership_id"], name: "index_check_requests_on_dealership_id"
  end

  create_table "data_syncs", force: :cascade do |t|
    t.bigint "dealership_id"
    t.string "provider_id"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dealership_id"], name: "index_data_syncs_on_dealership_id"
  end

  create_table "dealer_trades", force: :cascade do |t|
    t.bigint "dealership_id"
    t.string "trade_dealer_name"
    t.text "trade_dealer_address"
    t.string "trade_dealer_contact"
    t.string "trade_contact_phone"
    t.boolean "your_trade", default: false
    t.boolean "our_trade", default: false
    t.boolean "your_purchase", default: false
    t.boolean "our_purchase", default: false
    t.string "date_created"
    t.string "time_created"
    t.string "desk_manager"
    t.string "model"
    t.string "color"
    t.string "year"
    t.string "stock_number"
    t.string "vin"
    t.text "private_trade_notes"
    t.string "delivered_invoice"
    t.string "plus_deliver_acc"
    t.string "less_rebate_1"
    t.string "delivered_total"
    t.string "trade_model"
    t.string "trade_color"
    t.string "trade_year"
    t.string "trade_vin"
    t.string "trade_stock_number"
    t.string "received_invoice"
    t.string "received_acc"
    t.string "received_rebate"
    t.string "received_sum"
    t.text "public_trade_notes"
    t.string "trade_difference"
    t.string "trade_payment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dealer_code"
    t.index ["dealership_id"], name: "index_dealer_trades_on_dealership_id"
  end

  create_table "dealerships", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "map_bearing"
    t.decimal "map_zoom"
    t.date "custom_mtd_start_date"
    t.string "new_note_notification_addresses"
    t.string "new_service_ticket_notification_addresses"
  end

  create_table "deals", force: :cascade do |t|
    t.string "client_last_name"
    t.string "source"
    t.string "stock_number"
    t.string "trade"
    t.string "sales_rep"
    t.string "split_rep"
    t.string "city"
    t.string "model"
    t.string "make"
    t.boolean "is_used"
    t.string "year"
    t.string "result"
    t.string "report_status"
    t.string "deal_number"
    t.string "pay_method"
    t.string "deal_type"
    t.decimal "selling_price"
    t.decimal "down_payment"
    t.string "term"
    t.decimal "quoted_payment"
    t.string "rate_apr"
    t.string "miles_per_year"
    t.text "rebates"
    t.text "bulletin_number"
    t.string "desk_manager"
    t.string "finance_manager"
    t.boolean "dealer_demo", default: false
    t.boolean "loaner_car", default: false
    t.string "disclosure"
    t.decimal "trade_allowance"
    t.decimal "trade_acv"
    t.decimal "trade_payoff_amount"
    t.string "trade_bank_name"
    t.string "good_through_date"
    t.string "trade_account_number"
    t.text "send_payoff_address"
    t.string "time_agreed"
    t.string "time_in_finance"
    t.string "time_out_finance"
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "deal_notes"
    t.boolean "certified_pre_owned", default: false
    t.boolean "stored", default: false
    t.date "deal_date"
    t.string "bank_name"
    t.string "menu_number"
    t.string "deal_status"
    t.string "model_code"
    t.boolean "f_i_pre_sell", default: false
    t.text "f_i_pre_sell_product_list"
    t.index ["dealership_id"], name: "index_deals_on_dealership_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "tag_id"
    t.integer "event_type", default: 0
    t.text "event_details"
    t.boolean "acknowledged", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.index ["tag_id"], name: "index_events_on_tag_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "key_board_locations", force: :cascade do |t|
    t.string "name"
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dealership_id"], name: "index_key_board_locations_on_dealership_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "text"
    t.bigint "user_id"
    t.bigint "service_ticket_job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_ticket_job_id"], name: "index_notes_on_service_ticket_job_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "resolutions", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_resolutions_on_event_id"
    t.index ["user_id"], name: "index_resolutions_on_user_id"
  end

  create_table "service_ticket_jobs", force: :cascade do |t|
    t.text "title"
    t.bigint "service_ticket_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service_ticket_id"], name: "index_service_ticket_jobs_on_service_ticket_id"
    t.index ["user_id"], name: "index_service_ticket_jobs_on_user_id"
  end

  create_table "service_tickets", force: :cascade do |t|
    t.bigint "dealership_id"
    t.bigint "created_by_user_id"
    t.bigint "completed_by_user_id"
    t.string "stock_number"
    t.string "vin"
    t.string "mileage"
    t.string "year"
    t.string "make"
    t.string "model"
    t.string "color"
    t.string "status"
    t.datetime "complete_by_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "completed_at"
    t.index ["completed_by_user_id"], name: "index_service_tickets_on_completed_by_user_id"
    t.index ["created_by_user_id"], name: "index_service_tickets_on_created_by_user_id"
    t.index ["dealership_id"], name: "index_service_tickets_on_dealership_id"
  end

  create_table "shapes", force: :cascade do |t|
    t.json "geo_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shape_type"
    t.bigint "dealership_id"
    t.datetime "most_recently_tagged_at"
    t.index ["dealership_id"], name: "index_shapes_on_dealership_id"
  end

  create_table "suggested_trade_dealerships", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "contact"
    t.string "phone"
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dealer_code"
    t.index ["dealership_id"], name: "index_suggested_trade_dealerships_on_dealership_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "vehicle_id"
    t.bigint "shape_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shape_id"], name: "index_tags_on_shape_id"
    t.index ["vehicle_id"], name: "index_tags_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "dealership_id"
    t.integer "permission_level", default: 0
    t.boolean "accepted_service_license_agreement", default: false
    t.datetime "accepted_service_license_agreement_datetime"
    t.integer "status", default: 0
    t.index ["dealership_id"], name: "index_users_on_dealership_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "vin"
    t.string "make"
    t.string "model"
    t.string "year"
    t.string "color"
    t.integer "mileage", default: 0, null: false
    t.bigint "dealership_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stock_number"
    t.string "trim_level"
    t.string "doors"
    t.string "body_style"
    t.string "transmission"
    t.string "engine"
    t.string "engine_size"
    t.string "model_code"
    t.string "certified"
    t.string "retail_value"
    t.string "invoice_price"
    t.string "asking_price"
    t.string "wholesale_price"
    t.string "msrp"
    t.string "sale_price"
    t.string "vehicle_type"
    t.string "options"
    t.string "options_codes"
    t.string "comments"
    t.string "photo_url_list"
    t.string "package_code"
    t.string "fuel"
    t.string "drive_line"
    t.string "rear_wheel"
    t.string "status"
    t.text "raw_data_feed_output"
    t.integer "age_in_days", default: 0, null: false
    t.integer "creation_source", default: 0
    t.integer "usage_type"
    t.string "key_board_location_name"
    t.boolean "service_hold", default: false
    t.boolean "sales_hold", default: false
    t.text "service_hold_notes"
    t.text "sales_hold_notes"
    t.string "sold_status"
    t.string "sales_hold_creator"
    t.string "service_hold_creator"
    t.datetime "sales_hold_created_at"
    t.datetime "service_hold_created_at"
    t.index ["dealership_id"], name: "index_vehicles_on_dealership_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "data_syncs", "dealerships"
  add_foreign_key "notes", "service_ticket_jobs"
  add_foreign_key "notes", "users"
  add_foreign_key "resolutions", "events"
  add_foreign_key "resolutions", "users"
  add_foreign_key "service_ticket_jobs", "service_tickets"
  add_foreign_key "service_ticket_jobs", "users"
end
