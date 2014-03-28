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

ActiveRecord::Schema.define(version: 20140328122401) do

  create_table "areas", force: true do |t|
    t.string   "name",                       null: false
    t.string   "large",                      null: false
    t.string   "middle",                     null: false
    t.string   "small"
    t.string   "detail"
    t.boolean  "enabled",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["middle", "small", "detail"], name: "index_areas_on_middle_and_small_and_detail", unique: true

  create_table "hotels", force: true do |t|
    t.integer  "area_id",      null: false
    t.string   "no",           null: false
    t.string   "name",         null: false
    t.string   "postal_code",  null: false
    t.string   "address1",     null: false
    t.string   "address2",     null: false
    t.string   "telephone_no", null: false
    t.text     "image_url"
    t.text     "url"
    t.text     "access"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rooms", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
