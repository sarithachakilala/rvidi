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

ActiveRecord::Schema.define(:version => 20130624120822796) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "uid"
    t.string   "provider"
    t.string   "oauth_token"
    t.string   "ouath_token_secret"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "cameos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "director_id"
    t.integer  "show_id"
    t.integer  "show_order"
    t.string   "status"
    t.string   "name"
    t.string   "description"
    t.string   "thumbnail_url"
    t.string   "download_url"
    t.string   "kaltura_entry_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "title"
    t.string   "start_time"
    t.string   "end_time"
    t.float    "duration"
    t.string   "published_status"
  end

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.string   "user_name"
    t.integer  "show_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.integer  "request_from"
    t.string   "status"
    t.string   "friend_email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "invite_friends", :force => true do |t|
    t.integer  "director_id"
    t.integer  "show_id"
    t.integer  "contributor_id"
    t.string   "status"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "contributor_email"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "show_id"
    t.text     "content"
    t.string   "status"
    t.string   "to_email"
    t.boolean  "read_status", :default => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "profile_videos", :force => true do |t|
    t.integer  "user_id"
    t.string   "thumbnail_url"
    t.string   "download_url"
    t.string   "kaltura_entry_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shows", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "show_tag"
    t.text     "description"
    t.string   "display_preferences"
    t.string   "display_preferences_password"
    t.string   "contributor_preferences"
    t.string   "contributor_preferences_password"
    t.boolean  "need_review",                                     :default => true
    t.integer  "number_of_views"
    t.datetime "created_at",                                                         :null => false
    t.datetime "updated_at",                                                         :null => false
    t.datetime "end_set"
    t.string   "kaltura_playlist_id"
    t.float    "duration"
    t.string   "permalink",                        :limit => 128
    t.string   "download_url"
    t.boolean  "enable_download",                                 :default => false
    t.integer  "download_preference"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "profile_video_id"
    t.integer  "sign_in_count",          :default => 0
    t.text     "description"
    t.string   "image"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

end
