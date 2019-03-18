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

ActiveRecord::Schema.define(version: 2019_02_14_101958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "address", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "ip", null: false
    t.datetime "updated_at"
    t.bigint "network_id", null: false
    t.boolean "reserved", null: false
    t.integer "value", null: false
    t.binary "ip_old"
    t.integer "lock_version", default: 0, null: false
    t.string "ip_address", limit: 255
    t.bigint "user_id"
    t.index ["user_id"], name: "index_address_on_user_id"
  end

  create_table "assigned_address", id: :serial, force: :cascade do |t|
    t.bigint "address_id", null: false
    t.datetime "created_at", null: false
    t.string "description", limit: 255
    t.boolean "enabled", null: false
    t.bigint "hardware_id", null: false
    t.string "hostname", limit: 255
    t.datetime "updated_at"
    t.bigint "location_port_id"
    t.string "mac", limit: 255, null: false
    t.bigint "operator_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "last_seen_date"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_assigned_address_on_user_id"
  end

  create_table "collector", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description", null: false
    t.datetime "updated_at"
    t.bigint "location_id", null: false
    t.string "management_address", limit: 255
    t.string "name", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "collector_port", id: :serial, force: :cascade do |t|
    t.bigint "collector_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.integer "value", null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "hardware", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.string "name", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_hardware_on_user_id"
  end

  create_table "location", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.string "name", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_location_on_user_id"
  end

  create_table "location_port", id: :serial, force: :cascade do |t|
    t.bigint "collector_port_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.bigint "location_id", null: false
    t.string "name", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "network", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "dhcp_enabled", null: false
    t.string "gateway", limit: 255, null: false
    t.datetime "updated_at"
    t.string "name", limit: 255, null: false
    t.string "netmask", limit: 255, null: false
    t.string "server_dns", limit: 255, null: false
    t.integer "space", null: false
    t.string "start_address", limit: 255, null: false
    t.string "dns_zone", limit: 255
    t.string "pxefile", limit: 255
    t.integer "lock_version", default: 0, null: false
    t.string "default_lease_time", limit: 255, default: "43200", null: false
    t.string "max_lease_time", limit: 255, default: "86400", null: false
    t.string "netbios_name_servers", limit: 255
    t.string "netbios_node_type", limit: 255
    t.string "ntp_servers", limit: 255
    t.bigint "user_id"
    t.index ["user_id"], name: "index_network_on_user_id"
  end

  create_table "operator", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at"
    t.string "name", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_operator_on_user_id"
  end

  create_table "registration_code", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "token", limit: 255, null: false
    t.string "username", limit: 255, null: false
    t.integer "lock_version", default: 0, null: false
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name", limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "address", "users"
  add_foreign_key "assigned_address", "users"
  add_foreign_key "hardware", "users"
  add_foreign_key "location", "users"
  add_foreign_key "network", "users"
  add_foreign_key "operator", "users"
end
