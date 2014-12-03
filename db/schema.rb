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

ActiveRecord::Schema.define(version: 20141201151444) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address", force: true do |t|
    t.datetime "created_at",                         null: false
    t.text     "ip",                                 null: false
    t.datetime "updated_at"
    t.integer  "network_id",   limit: 8,             null: false
    t.boolean  "reserved",                           null: false
    t.integer  "value",                              null: false
    t.binary   "ip_old"
    t.integer  "lock_version",           default: 0, null: false
    t.string   "ip_address"
  end

  create_table "assigned_address", force: true do |t|
    t.integer  "address_id",       limit: 8,             null: false
    t.datetime "created_at",                             null: false
    t.string   "description"
    t.boolean  "enabled",                                null: false
    t.integer  "hardware_id",      limit: 8,             null: false
    t.string   "hostname"
    t.datetime "updated_at"
    t.integer  "location_port_id", limit: 8
    t.string   "mac",                                    null: false
    t.integer  "operator_id",      limit: 8,             null: false
    t.integer  "lock_version",               default: 0, null: false
  end

  create_table "collector", force: true do |t|
    t.datetime "created_at",                               null: false
    t.text     "description",                              null: false
    t.datetime "updated_at"
    t.integer  "location_id",        limit: 8,             null: false
    t.string   "management_address"
    t.string   "name",                                     null: false
    t.integer  "lock_version",                 default: 0, null: false
  end

  create_table "collector_port", force: true do |t|
    t.integer  "collector_id", limit: 8,             null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at"
    t.integer  "value",                              null: false
    t.integer  "lock_version",           default: 0, null: false
  end

  create_table "hardware", force: true do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at"
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
  end

  create_table "location", force: true do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at"
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
  end

  create_table "location_port", force: true do |t|
    t.integer  "collector_port_id", limit: 8
    t.datetime "created_at",                              null: false
    t.datetime "updated_at"
    t.integer  "location_id",       limit: 8,             null: false
    t.string   "name",                                    null: false
    t.integer  "lock_version",                default: 0, null: false
  end

  create_table "network", force: true do |t|
    t.datetime "created_at",                             null: false
    t.boolean  "dhcp_enabled",                           null: false
    t.string   "gateway",                                null: false
    t.datetime "updated_at"
    t.string   "name",                                   null: false
    t.string   "netmask",                                null: false
    t.string   "server_dns",                             null: false
    t.integer  "space",                                  null: false
    t.string   "start_address",                          null: false
    t.string   "dns_zone"
    t.string   "pxefile"
    t.integer  "lock_version",         default: 0,       null: false
    t.string   "default_lease_time",   default: "43200", null: false
    t.string   "max_lease_time",       default: "86400", null: false
    t.string   "netbios_name_servers"
    t.string   "netbios_node_type"
  end

  create_table "operator", force: true do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at"
    t.string   "name",                     null: false
    t.integer  "lock_version", default: 0, null: false
  end

  create_table "registration_code", force: true do |t|
    t.datetime "created_at",               null: false
    t.string   "token",                    null: false
    t.string   "username",                 null: false
    t.integer  "lock_version", default: 0, null: false
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
