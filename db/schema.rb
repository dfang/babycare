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

ActiveRecord::Schema.define(version: 20171023031214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_whitelists", force: :cascade do |t|
    t.string "uid"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_posts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.string "nickname"
    t.string "unionid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "checkins", force: :cascade do |t|
    t.string "name"
    t.string "mobile_phone"
    t.string "birthdate"
    t.string "gender"
    t.string "email"
    t.string "job"
    t.string "employer"
    t.string "nationality"
    t.string "province_id"
    t.string "city_id"
    t.string "area_id"
    t.string "address"
    t.string "source"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.integer "province_id"
    t.integer "level"
    t.string "zip_code"
    t.string "pinyin"
    t.string "pinyin_abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level"], name: "index_cities_on_level"
    t.index ["name"], name: "index_cities_on_name"
    t.index ["pinyin"], name: "index_cities_on_pinyin"
    t.index ["pinyin_abbr"], name: "index_cities_on_pinyin_abbr"
    t.index ["province_id"], name: "index_cities_on_province_id"
    t.index ["zip_code"], name: "index_cities_on_zip_code"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.integer "city_id"
    t.string "pinyin"
    t.string "pinyin_abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_districts_on_city_id"
    t.index ["name"], name: "index_districts_on_name"
    t.index ["pinyin"], name: "index_districts_on_pinyin"
    t.index ["pinyin_abbr"], name: "index_districts_on_pinyin_abbr"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "gender"
    t.integer "age"
    t.string "location"
    t.float "lat"
    t.float "long"
    t.boolean "verified"
    t.date "date_of_birth"
    t.string "mobile_phone"
    t.text "remark"
    t.string "id_card_num"
    t.string "id_card_front"
    t.string "id_card_back"
    t.string "license_front"
    t.string "license_back"
    t.string "job_title"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "good_at"
    t.integer "hospital_id"
    t.string "avatar"
    t.string "id_card_front_media_id"
    t.string "id_card_back_media_id"
    t.string "license_front_media_id"
    t.string "license_back_media_id"
    t.index ["user_id"], name: "index_doctors_on_user_id"
  end

  create_table "examination_groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examinations", force: :cascade do |t|
    t.string "name"
    t.bigint "examination_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examination_group_id"], name: "index_examinations_on_examination_group_id"
  end

  create_table "global_images", force: :cascade do |t|
    t.bigint "user_id"
    t.string "data"
    t.string "target_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_global_images_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.string "member_type"
    t.bigint "member_id", null: false
    t.string "group_type"
    t.bigint "group_id"
    t.string "group_name"
    t.string "membership_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_name"], name: "index_group_memberships_on_group_name"
    t.index ["group_type", "group_id"], name: "index_group_memberships_on_group_type_and_group_id"
    t.index ["member_type", "member_id"], name: "index_group_memberships_on_member_type_and_member_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hospitals", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "phone"
    t.string "nature"
    t.string "type"
    t.string "quality"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_hospitals_on_city_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imaging_examination_images", force: :cascade do |t|
    t.bigint "medical_record_id"
    t.string "data"
    t.boolean "is_cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "media_id"
    t.index ["medical_record_id"], name: "index_imaging_examination_images_on_medical_record_id"
  end

  create_table "laboratory_examination_images", force: :cascade do |t|
    t.bigint "medical_record_id"
    t.string "data"
    t.boolean "is_cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "media_id"
    t.index ["medical_record_id"], name: "index_laboratory_examination_images_on_medical_record_id"
  end

  create_table "medical_record_images", force: :cascade do |t|
    t.bigint "medical_record_id"
    t.string "data"
    t.boolean "is_cover"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "media_id"
    t.index ["medical_record_id"], name: "index_medical_record_images_on_medical_record_id"
  end

  create_table "medical_records", force: :cascade do |t|
    t.date "onset_date"
    t.text "chief_complaint"
    t.text "history_of_present_illness"
    t.text "past_medical_history"
    t.text "allergic_history"
    t.text "personal_history"
    t.text "family_history"
    t.text "vaccination_history"
    t.text "physical_examination"
    t.text "laboratory_and_supplementary_examinations"
    t.text "preliminary_diagnosis"
    t.text "treatment_recommendation"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "imaging_examination"
    t.integer "height"
    t.float "weight"
    t.float "bmi"
    t.float "temperature"
    t.integer "pulse"
    t.integer "respiratory_rate"
    t.integer "blood_pressure"
    t.string "oxygen_saturation"
    t.integer "pain_score"
    t.bigint "user_id"
    t.bigint "reservation_id"
    t.boolean "gender"
    t.date "birthdate"
    t.string "blood_type"
    t.string "name"
    t.string "identity_card"
    t.index ["reservation_id"], name: "index_medical_records_on_reservation_id"
    t.index ["user_id"], name: "index_medical_records_on_user_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "mobile_phone"
    t.date "birthdate"
    t.string "gender"
    t.string "email"
    t.string "job"
    t.string "employer"
    t.string "nationality"
    t.string "province_id"
    t.string "city_id"
    t.string "district_id"
    t.string "address"
    t.string "source"
    t.string "wechat"
    t.string "qq"
    t.text "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "blood_type"
  end

  create_table "phone_call_histories", force: :cascade do |t|
    t.integer "caller_user_id"
    t.string "caller_phone"
    t.integer "callee_user_id"
    t.string "callee_phone"
    t.bigint "reservation_id"
    t.string "reservation_state_when_call"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_phone_call_histories_on_reservation_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.text "body"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.string "pinyin"
    t.string "pinyin_abbr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_provinces_on_name"
    t.index ["pinyin"], name: "index_provinces_on_pinyin"
    t.index ["pinyin_abbr"], name: "index_provinces_on_pinyin_abbr"
  end

  create_table "ratings", force: :cascade do |t|
    t.float "stars"
    t.text "body"
    t.bigint "reservation_id"
    t.bigint "user_id"
    t.integer "rated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_ratings_on_reservation_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "reservation_examinations", force: :cascade do |t|
    t.bigint "reservation_id"
    t.bigint "examination_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["examination_id"], name: "index_reservation_examinations_on_examination_id"
    t.index ["reservation_id"], name: "index_reservation_examinations_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "name"
    t.string "mobile_phone"
    t.string "chief_complains"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.datetime "reservation_time"
    t.string "reservation_location"
    t.string "reservation_phone"
    t.integer "user_a"
    t.integer "user_b"
    t.string "gender"
    t.string "out_trade_pay_no"
    t.string "out_trade_prepay_no"
    t.integer "total_fee"
    t.integer "prepay_fee"
    t.integer "pay_fee"
    t.text "reservation_remark"
    t.string "reservation_name"
    t.string "reservation_type"
    t.integer "user_c"
  end

  create_table "simple_captchas", force: :cascade do |t|
    t.string "key", limit: 40
    t.string "value", limit: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sms_histories", force: :cascade do |t|
    t.integer "sender_user_id"
    t.string "sender_phone"
    t.integer "sendee_user_id"
    t.string "sendee_phone"
    t.bigint "reservation_id"
    t.string "reservation_state_when_sms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_id"
    t.index ["reservation_id"], name: "index_sms_histories_on_reservation_id"
  end

  create_table "symptoms", force: :cascade do |t|
    t.string "name"
    t.string "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.string "reservation_id"
    t.float "amount"
    t.string "source"
    t.string "withdraw_target"
    t.string "operation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "aasm_state"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "gender"
    t.string "avatar"
    t.string "mobile_phone"
    t.string "location"
    t.string "qrcode"
    t.string "ancestry"
    t.string "identity_card"
    t.date "birthdate"
    t.string "blood_type"
    t.text "history_of_present_illness"
    t.text "past_medical_history"
    t.text "allergic_history"
    t.text "personal_history"
    t.text "family_history"
    t.text "vaccination_history"
    t.index ["ancestry"], name: "index_users_on_ancestry"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.float "balance_withdrawable", default: 0.0
    t.float "balance_unwithdrawable", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "wx_menus", force: :cascade do |t|
    t.string "menu_type"
    t.string "name"
    t.string "key"
    t.string "url"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wx_sub_menus", force: :cascade do |t|
    t.bigint "wx_menu_id"
    t.string "menu_type"
    t.string "name"
    t.string "key"
    t.string "url"
    t.integer "sequence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wx_menu_id"], name: "index_wx_sub_menus_on_wx_menu_id"
  end

  add_foreign_key "doctors", "users"
  add_foreign_key "global_images", "users"
  add_foreign_key "hospitals", "cities"
  add_foreign_key "imaging_examination_images", "medical_records"
  add_foreign_key "laboratory_examination_images", "medical_records"
  add_foreign_key "medical_record_images", "medical_records"
  add_foreign_key "medical_records", "reservations"
  add_foreign_key "phone_call_histories", "reservations"
  add_foreign_key "ratings", "reservations"
  add_foreign_key "ratings", "users"
  add_foreign_key "reservation_examinations", "examinations"
  add_foreign_key "reservation_examinations", "reservations"
  add_foreign_key "sms_histories", "reservations"
  add_foreign_key "transactions", "users"
  add_foreign_key "wallets", "users"
  add_foreign_key "wx_sub_menus", "wx_menus"
end
