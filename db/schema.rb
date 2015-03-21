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

ActiveRecord::Schema.define(version: 20150317212917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: :cascade do |t|
    t.integer  "therapy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "calendars", ["therapy_id"], name: "index_calendars_on_therapy_id", using: :btree

  create_table "exercise_days", force: :cascade do |t|
    t.date     "date"
    t.integer  "timetable_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "exercise_templates", force: :cascade do |t|
    t.string   "weekday_template_id"
    t.time     "beginning"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "exercises", force: :cascade do |t|
    t.time     "beginning"
    t.integer  "exercise_day_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "available",       default: true
  end

  create_table "therapies", force: :cascade do |t|
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "duration_in_minutes"
  end

  create_table "timetable_templates", force: :cascade do |t|
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "timetables", force: :cascade do |t|
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "timetables", ["calendar_id"], name: "index_timetables_on_calendar_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "access_level"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "weekday_templates", force: :cascade do |t|
    t.integer  "weekday"
    t.integer  "timetable_template_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

end
