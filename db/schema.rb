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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20140729153755) do
=======
ActiveRecord::Schema.define(version: 20140730005937) do
>>>>>>> 266aef3aaaabc78ee430c7adf7582e0879b2a847

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: true do |t|
    t.string "name"
    t.string "spotify_id"
  end

  create_table "artists_genres", id: false, force: true do |t|
    t.integer "artist_id", null: false
    t.integer "genre_id",  null: false
  end

  create_table "favorites", force: true do |t|
    t.boolean  "liked_back"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fav_initiator_id"
    t.integer  "fav_receiver_id"
  end

  create_table "genres", force: true do |t|
    t.string "name"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "favorite_id"
    t.string   "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["favorite_id"], name: "index_messages_on_favorite_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "tracks", force: true do |t|
    t.string  "spotify_id"
    t.string  "name"
    t.integer "user_id"
    t.integer "artist_id"
  end

  add_index "tracks", ["spotify_id"], name: "index_tracks_on_spotify_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uid"
    t.string   "provider"
    t.string   "name"
    t.string   "image"
    t.string   "age"
    t.string   "gender"
    t.string   "interested_in"
    t.string   "display_name"
    t.string   "location"
    t.string   "bio"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
