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

ActiveRecord::Schema.define(version: 2022_05_15_023033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "administrators", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
  end

  create_table "golfers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "identifier"
    t.integer "handicap"
    t.boolean "medical_status"
    t.boolean "bypass_limit", default: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer "golfer_id"
    t.integer "gross_score"
    t.integer "handicap"
    t.date "occurred_on"
    t.boolean "medical_status"
  end

end
