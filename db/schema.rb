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

ActiveRecord::Schema.define(version: 20131215192222) do

  create_table "categories", force: true do |t|
    t.string "name"
    t.string "type"
  end

  create_table "categories_resources", force: true do |t|
    t.integer "resource_id"
    t.integer "category_id"
  end

  create_table "people", force: true do |t|
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "props", force: true do |t|
    t.decimal  "price"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.text     "description"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources_tags", id: false, force: true do |t|
    t.integer "tag_id"
    t.integer "resource_id"
  end

  create_table "samples", force: true do |t|
    t.integer  "categories_resource_id"
    t.string   "sample_file_name"
    t.string   "sample_content_type"
    t.integer  "sample_file_size"
    t.datetime "sample_updated_at"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", force: true do |t|
    t.string "tag"
    t.string "resource"
    t.string "category"
  end

  create_table "users", force: true do |t|
    t.integer  "resource_id"
    t.boolean  "admin"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "venues", force: true do |t|
    t.string   "address"
    t.integer  "latitude"
    t.integer  "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
