class DefineInitialAppTablesFromOldApp < ActiveRecord::Migration[4.2]
  def change
    create_table "address", force: true do |t|
      t.integer  "version",      limit: 8, null: false
      t.datetime "date_created",           null: false
      t.binary   "ip",                     null: false
      t.datetime "last_updated"
      t.integer  "network_id",   limit: 8, null: false
      t.boolean  "reserved",               null: false
      t.integer  "value",                  null: false
    end

    create_table "assigned_address", force: true do |t|
      t.integer  "version",          limit: 8, null: false
      t.integer  "address_id",       limit: 8, null: false
      t.datetime "date_created",               null: false
      t.string   "description"
      t.boolean  "enabled",                    null: false
      t.integer  "hardware_id",      limit: 8, null: false
      t.string   "hostname"
      t.datetime "last_updated"
      t.integer  "location_port_id", limit: 8
      t.string   "mac",                        null: false
      t.integer  "operator_id",      limit: 8, null: false
    end

    create_table "collector", force: true do |t|
      t.integer  "version",            limit: 8, null: false
      t.datetime "date_created",                 null: false
      t.text     "description",                  null: false
      t.datetime "last_updated"
      t.integer  "location_id",        limit: 8, null: false
      t.string   "management_address"
      t.string   "name",                         null: false
    end

    create_table "collector_port", force: true do |t|
      t.integer  "version",      limit: 8, null: false
      t.integer  "collector_id", limit: 8, null: false
      t.datetime "date_created",           null: false
      t.datetime "last_updated"
      t.integer  "value",                  null: false
    end

    create_table "hardware", force: true do |t|
      t.integer  "version",      limit: 8, null: false
      t.datetime "date_created",           null: false
      t.datetime "last_updated"
      t.string   "name",                   null: false
    end

    create_table "location", force: true do |t|
      t.integer  "version",      limit: 8, null: false
      t.datetime "date_created",           null: false
      t.datetime "last_updated"
      t.string   "name",                   null: false
    end

    create_table "location_port", force: true do |t|
      t.integer  "version",           limit: 8, null: false
      t.integer  "collector_port_id", limit: 8
      t.datetime "date_created",                null: false
      t.datetime "last_updated"
      t.integer  "location_id",       limit: 8, null: false
      t.string   "name",                        null: false
    end

    create_table "network", force: true do |t|
      t.integer  "version",       limit: 8, null: false
      t.datetime "date_created",            null: false
      t.boolean  "dhcp_enabled",            null: false
      t.string   "gateway",                 null: false
      t.datetime "last_updated"
      t.string   "name",                    null: false
      t.string   "netmask",                 null: false
      t.string   "server_dns",              null: false
      t.integer  "space",                   null: false
      t.string   "start_address",           null: false
      t.string   "dns_zone"
      t.string   "pxefile"
    end

    create_table "operator", force: true do |t|
      t.integer  "version",      limit: 8, null: false
      t.datetime "date_created",           null: false
      t.datetime "last_updated"
      t.string   "name",                   null: false
    end

    create_table "registration_code", force: true do |t|
      t.datetime "date_created",           null: false
      t.string   "token",                  null: false
      t.string   "username",               null: false
    end
      
  end
end
