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

ActiveRecord::Schema.define(version: 20170122005858) do

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
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
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
    t.string   "grp_rt_indicator"
    t.string   "ult_grp_rt_indicator"
    t.string   "franch_indicator"
    t.string   "site_franchise"
    t.string   "sfdc_franchise"
    t.string   "site_ult_rt"
    t.string   "site_grp_rt"
    t.string   "grp_name_indicator"
    t.string   "ult_grp_name_indicator"
    t.string   "tier_indicator"
    t.string   "site_tier"
    t.string   "site_franch_cat"
    t.string   "sfdc_franch_cat"
    t.string   "site_ult_grp"
    t.string   "site_group"
    t.string   "acct_source"
    t.string   "sfdc_geo_addy"
    t.float    "sfdc_lat"
    t.float    "sfdc_lon"
    t.string   "site_geo_addy"
    t.float    "site_lat"
    t.float    "site_lon"
    t.string   "sfdc_geo_status"
    t.string   "site_geo_status"
    t.datetime "sfdc_geo_date"
    t.datetime "site_geo_date"
    t.string   "sfdc_coordinates"
    t.string   "site_coordinates"
    t.string   "sfdc_franch_cons"
    t.string   "site_franch_cons"
    t.string   "temp_id"
    t.string   "coord_indicator"
    t.string   "franch_cons_ind"
    t.string   "franch_cat_ind"
    t.string   "template_ind"
    t.string   "sfdc_template"
    t.string   "site_template"
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

  create_table "dashboards", force: :cascade do |t|
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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "consolidated_term"
    t.string   "category"
  end

  create_table "in_text_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_pos", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "consolidated_term"
    t.string   "category"
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

  create_table "locations", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "city"
    t.string   "state"
    t.string   "state_code"
    t.string   "postal_code"
    t.string   "coordinates"
    t.string   "acct_name"
    t.string   "group_name"
    t.string   "ult_group_name"
    t.string   "source"
    t.string   "sfdc_id"
    t.string   "tier"
    t.string   "sales_person"
    t.string   "acct_type"
    t.string   "location_status"
    t.string   "rev_full_address"
    t.string   "rev_street"
    t.string   "rev_city"
    t.string   "rev_state"
    t.string   "rev_state_code"
    t.string   "rev_postal_code"
    t.string   "url"
    t.string   "root"
    t.string   "franchise"
    t.string   "street"
    t.string   "address"
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
    t.string   "sfdc_cont_id"
    t.string   "template"
    t.datetime "staffer_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "staff_link"
    t.string   "staff_text"
    t.integer  "sfdc_cont_active"
    t.string   "sfdc_tier"
    t.string   "domain"
    t.string   "acct_name"
    t.string   "group_name"
    t.string   "ult_group_name"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "fname"
    t.string   "lname"
    t.string   "fullname"
    t.string   "job"
    t.string   "job_raw"
    t.string   "phone"
    t.string   "email"
    t.string   "influence"
    t.string   "cell_phone"
    t.datetime "last_activity_date"
    t.datetime "created_date"
    t.datetime "updated_date"
    t.string   "franchise"
  end

end
