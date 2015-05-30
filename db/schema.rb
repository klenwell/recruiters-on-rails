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

ActiveRecord::Schema.define(version: 20150505050236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "interviews", force: :cascade do |t|
    t.integer  "recruiter_id"
    t.date     "date"
    t.string   "company"
    t.integer  "culture",      default: 1
    t.integer  "people",       default: 1
    t.integer  "work",         default: 1
    t.integer  "career",       default: 1
    t.integer  "commute",      default: 1
    t.integer  "salary",       default: 1
    t.integer  "gut",          default: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "interviewer"
    t.string   "kind"
    t.text     "notes"
    t.string   "result"
  end

  add_index "interviews", ["recruiter_id"], name: "index_interviews_on_recruiter_id", using: :btree

  create_table "merits", force: :cascade do |t|
    t.integer  "recruiter_id"
    t.string   "reason"
    t.integer  "value"
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "merits", ["recruiter_id"], name: "index_merits_on_recruiter_id", using: :btree

  create_table "pings", force: :cascade do |t|
    t.integer  "recruiter_id"
    t.string   "kind"
    t.string   "note"
    t.text     "transcript"
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "recruiter_lists", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recruiters", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "company"
    t.string   "phone"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "recruiter_list_id"
  end

  add_index "recruiters", ["recruiter_list_id"], name: "index_recruiters_on_recruiter_list_id", using: :btree

  add_foreign_key "interviews", "recruiters"
  add_foreign_key "merits", "recruiters"
end
