class AddNetbiosServerOnNetworks < ActiveRecord::Migration
  def change
    add_column :network, :netbios_name_servers, :string
    add_column :network, :netbios_node_type, :string
  end
end
