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

ActiveRecord::Schema.define(version: 20161112154024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

end
