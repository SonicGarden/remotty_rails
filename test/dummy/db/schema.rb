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

ActiveRecord::Schema.define(version: 20151208073145) do

  create_table "remotty_rails_participations", force: :cascade do |t|
    t.integer  "remotty_rails_room_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "remotty_rails_participations", ["remotty_rails_room_id"], name: "index_remotty_rails_participations_on_remotty_rails_room_id"

  create_table "remotty_rails_rooms", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remotty_rails_users", force: :cascade do |t|
    t.integer  "remotty_rails_participation_id"
    t.string   "email"
    t.string   "name"
    t.string   "icon_url"
    t.string   "token"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "remotty_rails_users", ["remotty_rails_participation_id"], name: "index_remotty_rails_users_on_remotty_rails_participation_id"

end
