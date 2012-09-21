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

ActiveRecord::Schema.define(:version => 20120921155726) do

  create_table "duties", :force => true do |t|
    t.time     "starts"
    t.time     "ends"
    t.date     "day"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.integer  "rotum_id"
    t.integer  "preferences_count"
  end

  add_index "duties", ["rotum_id"], :name => "rotum_id"
  add_index "duties", ["user_id"], :name => "index_duties_on_user_id"

  create_table "duties_users", :id => false, :force => true do |t|
    t.integer "duty_id", :null => false
    t.integer "user_id", :null => false
  end

  add_index "duties_users", ["duty_id", "user_id"], :name => "index_duties_users_on_duty_id_and_user_id", :unique => true

  create_table "events", :force => true do |t|
    t.string   "name"
    t.date     "day"
    t.time     "duty_starts"
    t.time     "duty_ends"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "duty_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "preferences", ["duty_id"], :name => "index_preferences_on_duty_id"
  add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "rota", :force => true do |t|
    t.date     "starts"
    t.date     "ends"
    t.boolean  "assigned"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "published",  :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.date     "deleted_at"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "extension"
    t.string   "mobile"
    t.string   "residence"
    t.string   "email"
    t.string   "responsibilites"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
