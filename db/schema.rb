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

ActiveRecord::Schema.define(version: 20160830094017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "authentications", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "nickname"
    t.string   "unionid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.string   "birthdate"
    t.string   "gender"
    t.string   "email"
    t.string   "job"
    t.string   "employer"
    t.string   "nationality"
    t.string   "province_id"
    t.string   "city_id"
    t.string   "area_id"
    t.string   "address"
    t.string   "source"
    t.text     "remark"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.integer  "province_id"
    t.integer  "level"
    t.string   "zip_code"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["level"], name: "index_cities_on_level", using: :btree
  add_index "cities", ["name"], name: "index_cities_on_name", using: :btree
  add_index "cities", ["pinyin"], name: "index_cities_on_pinyin", using: :btree
  add_index "cities", ["pinyin_abbr"], name: "index_cities_on_pinyin_abbr", using: :btree
  add_index "cities", ["province_id"], name: "index_cities_on_province_id", using: :btree
  add_index "cities", ["zip_code"], name: "index_cities_on_zip_code", using: :btree

  create_table "districts", force: :cascade do |t|
    t.string   "name"
    t.integer  "city_id"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["city_id"], name: "index_districts_on_city_id", using: :btree
  add_index "districts", ["name"], name: "index_districts_on_name", using: :btree
  add_index "districts", ["pinyin"], name: "index_districts_on_pinyin", using: :btree
  add_index "districts", ["pinyin_abbr"], name: "index_districts_on_pinyin_abbr", using: :btree

  create_table "doctors", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "age"
    t.string   "hospital"
    t.string   "location"
    t.float    "lat"
    t.float    "long"
    t.boolean  "verified"
    t.date     "date_of_birth"
    t.string   "mobile_phone"
    t.text     "remark"
    t.string   "id_card_num"
    t.string   "id_card_front"
    t.string   "id_card_back"
    t.string   "license_front"
    t.string   "license_back"
    t.string   "job_title"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "doctors", ["user_id"], name: "index_doctors_on_user_id", using: :btree

  create_table "global_images", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "data"
    t.string   "target_type"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "global_images", ["user_id"], name: "index_global_images_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imaging_examination_images", force: :cascade do |t|
    t.integer  "medical_record_id"
    t.string   "data"
    t.boolean  "is_cover"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "imaging_examination_images", ["medical_record_id"], name: "index_imaging_examination_images_on_medical_record_id", using: :btree

  create_table "laboratory_examination_images", force: :cascade do |t|
    t.integer  "medical_record_id"
    t.string   "data"
    t.boolean  "is_cover"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "laboratory_examination_images", ["medical_record_id"], name: "index_laboratory_examination_images_on_medical_record_id", using: :btree

  create_table "medical_record_images", force: :cascade do |t|
    t.integer  "medical_record_id"
    t.string   "data"
    t.boolean  "is_cover"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "medical_record_images", ["medical_record_id"], name: "index_medical_record_images_on_medical_record_id", using: :btree

  create_table "medical_records", force: :cascade do |t|
    t.integer  "person_id"
    t.date     "onset_date"
    t.text     "chief_complaint"
    t.text     "history_of_present_illness"
    t.text     "past_medical_history"
    t.boolean  "allergic_history"
    t.text     "personal_history"
    t.text     "family_history"
    t.text     "vaccination_history"
    t.text     "physical_examination"
    t.text     "laboratory_and_supplementary_examinations"
    t.text     "preliminary_diagnosis"
    t.text     "treatment_recommendation"
    t.text     "remarks"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.text     "imaging_examination"
    t.integer  "height"
    t.float    "weight"
    t.float    "bmi"
    t.float    "temperature"
    t.integer  "pulse"
    t.integer  "respiratory_rate"
    t.integer  "blood_pressure"
    t.string   "oxygen_saturation"
    t.integer  "pain_score"
  end

  add_index "medical_records", ["person_id"], name: "index_medical_records_on_person_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.date     "birthdate"
    t.string   "gender"
    t.string   "email"
    t.string   "job"
    t.string   "employer"
    t.string   "nationality"
    t.string   "province_id"
    t.string   "city_id"
    t.string   "district_id"
    t.string   "address"
    t.string   "source"
    t.string   "wechat"
    t.string   "qq"
    t.text     "remark"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.integer  "children_count"
    t.string   "blood_type"
  end

  create_table "phone_call_histories", force: :cascade do |t|
    t.integer  "caller_user_id"
    t.string   "caller_phone"
    t.integer  "callee_user_id"
    t.string   "callee_phone"
    t.integer  "reservation_id"
    t.string   "reservation_state_when_call"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "phone_call_histories", ["reservation_id"], name: "index_phone_call_histories_on_reservation_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.text     "body"
    t.boolean  "published",   default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "provinces", force: :cascade do |t|
    t.string   "name"
    t.string   "pinyin"
    t.string   "pinyin_abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "provinces", ["name"], name: "index_provinces_on_name", using: :btree
  add_index "provinces", ["pinyin"], name: "index_provinces_on_pinyin", using: :btree
  add_index "provinces", ["pinyin_abbr"], name: "index_provinces_on_pinyin_abbr", using: :btree

  create_table "reservations", force: :cascade do |t|
    t.string   "name"
    t.string   "mobile_phone"
    t.string   "remark"
    t.string   "location"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "aasm_state"
    t.datetime "reservation_time"
    t.string   "reservation_location"
    t.string   "reservation_phone"
    t.integer  "user_a"
    t.integer  "user_b"
    t.string   "child_gender"
    t.string   "out_trade_no"
  end

  create_table "sms_histories", force: :cascade do |t|
    t.integer  "sender_user_id"
    t.string   "sender_phone"
    t.integer  "sendee_user_id"
    t.string   "sendee_phone"
    t.integer  "reservation_id"
    t.string   "reservation_state_when_sms"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "sms_histories", ["reservation_id"], name: "index_sms_histories_on_reservation_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "gender"
    t.string   "avatar"
    t.string   "mobile_phone"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wx_menus", force: :cascade do |t|
    t.string   "menu_type"
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.integer  "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wx_sub_menus", force: :cascade do |t|
    t.integer  "wx_menu_id"
    t.string   "menu_type"
    t.string   "name"
    t.string   "key"
    t.string   "url"
    t.integer  "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wx_sub_menus", ["wx_menu_id"], name: "index_wx_sub_menus_on_wx_menu_id", using: :btree

  add_foreign_key "doctors", "users"
  add_foreign_key "global_images", "users"
  add_foreign_key "imaging_examination_images", "medical_records"
  add_foreign_key "laboratory_examination_images", "medical_records"
  add_foreign_key "medical_record_images", "medical_records"
  add_foreign_key "medical_records", "people"
  add_foreign_key "phone_call_histories", "reservations"
  add_foreign_key "sms_histories", "reservations"
  add_foreign_key "wx_sub_menus", "wx_menus"
end
