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

ActiveRecord::Schema.define(version: 20160503143525) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "available_values", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendars", force: :cascade do |t|
    t.integer  "therapy_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "calendars", ["therapy_id"], name: "index_calendars_on_therapy_id", using: :btree

  create_table "coaches", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
    t.string   "color_code"
    t.string   "photo"
  end

  create_table "entries", force: :cascade do |t|
    t.integer  "exercise_id"
    t.integer  "ticket_id"
    t.string   "message"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "exercise_modifications", force: :cascade do |t|
    t.integer  "exercise_template_id"
    t.datetime "date"
    t.integer  "coach_id"
    t.string   "price"
    t.text     "note"
    t.integer  "timetable_modification_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "removal"
  end

  create_table "exercise_templates", force: :cascade do |t|
    t.time     "beginning"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "weekday"
    t.integer  "timetable_template_id"
    t.string   "price"
    t.integer  "coach_id"
    t.text     "note"
  end

  create_table "exercises", force: :cascade do |t|
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "available",                default: true
    t.integer  "timetable_id"
    t.integer  "exercise_modification_id"
  end

  create_table "goals", force: :cascade do |t|
    t.integer  "tracked_value_id"
    t.float    "value"
    t.date     "date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "records", force: :cascade do |t|
    t.integer  "tracked_value_id"
    t.float    "value"
    t.date     "date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "therapies", force: :cascade do |t|
    t.string   "name"
    t.integer  "capacity"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "duration_in_minutes"
    t.integer  "single_use_category_id"
    t.integer  "sorting_order"
  end

  create_table "therapies_therapy_categories", id: false, force: :cascade do |t|
    t.integer "therapy_id"
    t.integer "therapy_category_id"
  end

  add_index "therapies_therapy_categories", ["therapy_category_id"], name: "index_therapies_therapy_categories_on_therapy_category_id", using: :btree
  add_index "therapies_therapy_categories", ["therapy_id"], name: "index_therapies_therapy_categories_on_therapy_id", using: :btree

  create_table "therapy_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "entries_remaining"
    t.datetime "activated_on"
    t.boolean  "paid",                default: true
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "therapy_category_id"
    t.integer  "time_restriction"
    t.boolean  "single_use"
  end

  create_table "timetable_modifications", force: :cascade do |t|
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "timetable_templates", force: :cascade do |t|
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "beginning"
  end

  create_table "timetables", force: :cascade do |t|
    t.integer  "calendar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "timetables", ["calendar_id"], name: "index_timetables_on_calendar_id", using: :btree

  create_table "tracked_values", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "available_value_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "access_level"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "note"
    t.string   "verification_token"
  end

end
