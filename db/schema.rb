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

ActiveRecord::Schema.define(version: 20161128052948) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cores", force: :cascade do |t|
    t.string   "bds_status"
    t.string   "sfdc_id"
    t.integer  "sfdc_tier"
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
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
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
    t.string   "sfdc_id"
    t.string   "sfdc_ult_acct"
    t.string   "sfdc_acct"
    t.string   "sfdc_type"
    t.string   "sfdc_street"
    t.string   "sfdc_city"
    t.string   "sfdc_state"
    t.string   "sfdc_url_o"
    t.string   "domain_status"
    t.string   "domain"
    t.string   "root"
    t.string   "suffix"
    t.string   "in_host_pos"
    t.string   "in_host_neg"
    t.string   "in_host_del"
    t.string   "in_suffix_del"
    t.string   "exclude_root"
    t.string   "text"
    t.string   "in_text_pos"
    t.string   "in_text_neg"
    t.string   "in_text_del"
    t.string   "url_encoded"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "in_host_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_host_negs", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_host_pos", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_suffix_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_dels", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_negs", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "in_text_pos", force: :cascade do |t|
    t.string   "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
