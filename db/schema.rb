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

ActiveRecord::Schema.define(version: 20140403121554) do

  create_table "areas", force: true do |t|
    t.string   "long_name",                  null: false
    t.string   "short_name"
    t.string   "large",                      null: false
    t.string   "middle",                     null: false
    t.string   "small"
    t.string   "detail"
    t.boolean  "enabled",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "areas", ["middle", "small", "detail"], name: "index_areas_on_middle_and_small_and_detail", unique: true

  create_table "charge_histories", force: true do |t|
    t.integer  "charge_id"
    t.datetime "researched_at",                null: false
    t.integer  "amount",        default: 0,    null: false
    t.boolean  "can_stay",      default: true, null: false
  end

  add_index "charge_histories", ["charge_id"], name: "index_charge_histories_on_charge_id"

  create_table "charges", force: true do |t|
    t.integer  "hotel_id"
    t.integer  "room_id"
    t.integer  "plan_id"
    t.integer  "stay_day",                  null: false
    t.integer  "amount",     default: 0,    null: false
    t.boolean  "can_stay",   default: true, null: false
    t.boolean  "executed",   default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "charges", ["hotel_id"], name: "index_charges_on_hotel_id"
  add_index "charges", ["plan_id"], name: "index_charges_on_plan_id"
  add_index "charges", ["room_id", "plan_id", "stay_day"], name: "index_charges_on_room_id_and_plan_id_and_stay_day", unique: true
  add_index "charges", ["room_id"], name: "index_charges_on_room_id"

  create_table "hotels", force: true do |t|
    t.integer  "area_id",                      null: false
    t.string   "no",                           null: false
    t.string   "long_name",                    null: false
    t.string   "short_name"
    t.string   "postal_code",                  null: false
    t.string   "address1",                     null: false
    t.string   "address2",                     null: false
    t.string   "telephone_no",                 null: false
    t.text     "image_url"
    t.text     "url"
    t.text     "access"
    t.string   "latitude"
    t.string   "longitude"
    t.integer  "room_num",     default: 0
    t.boolean  "enabled",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", force: true do |t|
    t.integer  "hotel_id"
    t.integer  "code",                           null: false
    t.text     "long_name"
    t.string   "short_name"
    t.integer  "payment_code",   default: 1,     null: false
    t.text     "description"
    t.integer  "point_rate",     default: 0
    t.boolean  "with_dinner",    default: false
    t.boolean  "with_breakfast", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["hotel_id"], name: "index_plans_on_hotel_id"

  create_table "rooms", force: true do |t|
    t.integer  "hotel_id",                   null: false
    t.string   "code",                       null: false
    t.string   "name",                       null: false
    t.boolean  "smoking",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.string   "crypted_password",                       null: false
    t.string   "salt",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "failed_logins_count",        default: 0
    t.datetime "lock_expires_at"
    t.string   "unlock_token"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"

end
