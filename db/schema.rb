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

ActiveRecord::Schema.define(version: 20161231035230) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cores", force: :cascade do |t|
    t.string   "bds_status"
    t.string   "sfdc_id"
    t.string   "sfdc_tier"
    t.string   "sfdc_sales_person"
    t.string   "sfdc_type"
    t.string   "sfdc_ult_grp"
    t.integer  "sfdc_ult_rt"
    t.string   "sfdc_group"
    t.integer  "sfdc_grp_rt"
    t.string   "sfdc_acct"
    t.string   "sfdc_street"
    t.string   "sfdc_city"
    t.string   "sfdc_state"
    t.integer  "sfdc_zip"
    t.string   "sfdc_ph"
    t.string   "sfdc_url"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "core_date"
    t.datetime "domainer_date"
    t.datetime "indexer_date"
    t.datetime "staffer_date"
    t.datetime "whois_date"
    t.string   "matched_url"
    t.string   "matched_root"
    t.string   "url_comparison"
    t.string   "root_comparison"
    t.string   "sfdc_root"
    t.string   "staff_indexer_status"
    t.string   "location_indexer_status"
    t.string   "inventory_indexer_status"
    t.string   "staff_link"
    t.string   "staff_text"
    t.string   "location_link"
    t.string   "location_text"
    t.string   "domain_status"
    t.string   "staffer_status"
    t.string   "acct_indicator"
    t.string   "sfdc_group_indicator"
    t.string   "sfdc_ult_grp_indicator"
    t.string   "template"
    t.string   "site_acct"
    t.string   "site_street"
    t.string   "site_city"
    t.string   "site_state"
    t.integer  "site_zip"
    t.string   "site_ph"
    t.string   "street_indicator"
    t.string   "city_indicator"
    t.string   "state_indicator"
    t.string   "zip_indicator"
    t.string   "ph_indicator"
    t.string   "verified_ult_rt_indicator"
    t.string   "verified_grp_rt_indicator"
    t.string   "grp_rt_indicator"
    t.string   "ult_grp_rt_indicator"
    t.string   "sfdc_franch_indicator"
    t.string   "site_franch_indicator"
    t.string   "franch_indicator"
  end

  create_table "criteria_indexer_loc_hrefs", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria_indexer_loc_texts", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria_indexer_staff_hrefs", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "criteria_indexer_staff_texts", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "exclude_roots", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gcses", force: :cascade do |t|
    t.datetime "gcse_timestamp"
    t.integer  "gcse_query_num"
    t.integer  "gcse_result_num"
    t.string   "domain_status"
    t.string   "domain"
    t.string   "root"
    t.string   "suffix"
    t.string   "in_host_pos"
    t.string   "exclude_root"
    t.string   "text"
    t.string   "in_text_pos"
    t.string   "in_text_del"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "root_counter"
    t.string   "sfdc_id"
    t.string   "sfdc_ult_acct"
    t.string   "sfdc_acct"
    t.string   "sfdc_type"
    t.string   "sfdc_street"
    t.string   "sfdc_city"
    t.string   "sfdc_state"
    t.string   "sfdc_url_o"
    t.string   "sfdc_root"
  end

  create_table "in_host_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_host_pos", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_pos", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "indexer_locations", force: :cascade do |t|
    t.string   "indexer_status"
    t.string   "sfdc_acct"
    t.string   "sfdc_group_name"
    t.string   "sfdc_ult_acct"
    t.string   "domain"
    t.string   "ip"
    t.string   "text"
    t.string   "href"
    t.string   "link"
    t.string   "sfdc_id"
    t.datetime "indexer_timestamp"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "indexer_staffs", force: :cascade do |t|
    t.string   "indexer_status"
    t.string   "sfdc_acct"
    t.string   "sfdc_group_name"
    t.string   "sfdc_ult_acct"
    t.string   "domain"
    t.string   "ip"
    t.string   "text"
    t.string   "href"
    t.string   "link"
    t.string   "sfdc_id"
    t.datetime "indexer_timestamp"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "pending_verifications", force: :cascade do |t|
    t.string   "root"
    t.string   "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "solitaries", force: :cascade do |t|
    t.string   "solitary_root"
    t.string   "solitary_url"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "staffers", force: :cascade do |t|
    t.string   "staffer_status"
    t.string   "cont_status"
    t.string   "cont_source"
    t.string   "sfdc_id"
    t.string   "sfdc_sales_person"
    t.string   "sfdc_type"
    t.string   "sfdc_acct"
    t.string   "site_acct"
    t.string   "sfdc_group"
    t.string   "sfdc_ult_grp"
    t.string   "site_street"
    t.string   "site_city"
    t.string   "site_state"
    t.integer  "site_zip"
    t.string   "site_ph"
    t.string   "sfdc_cont_fname"
    t.string   "sfdc_cont_lname"
    t.string   "sfdc_cont_job"
    t.string   "sfdc_cont_phone"
    t.string   "sfdc_cont_email"
    t.string   "sfdc_cont_inactive"
    t.string   "sfdc_cont_id"
    t.integer  "sfdc_cont_influence"
    t.string   "site_cont_fname"
    t.string   "site_cont_lname"
    t.string   "site_cont_fullname"
    t.string   "site_cont_job"
    t.string   "site_cont_job_raw"
    t.string   "site_cont_phone"
    t.string   "site_cont_email"
    t.integer  "site_cont_influence"
    t.string   "template"
    t.datetime "staffer_date"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
