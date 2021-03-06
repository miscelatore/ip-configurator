class AddFieldsOnNetworks < ActiveRecord::Migration[4.2]
  def change
    add_column :network, :default_lease_time, :string, null: false, default: "43200"
    add_column :network, :max_lease_time, :string, null: false, default: "86400"
  end
end
