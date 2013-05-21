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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130521105608) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cameos", :force => true do |t|
    t.integer  "video_id"
    t.integer  "user_id"
    t.integer  "director_id"
    t.string   "status"
    t.integer  "show_id"
    t.integer  "show_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "friend_mappings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.text     "content"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "city"
    t.string   "country"
    t.string   "provide"
    t.string   "name"
    t.string   "uid"
    t.integer  "profile_video_id"
    t.text     "description"
    t.string   "oauth_token"
    t.datetime "oauth_exprites_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "shows", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "profile_video_id"
    t.text     "description"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "sign_in_count",    :default => 0
  end

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "cameo_id"
    t.string   "video_file"
    t.string   "kaltura_key"
    t.datetime "kaltura_syncd_at"
    t.string   "thumbnail_url"
    t.integer  "duration"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

end
