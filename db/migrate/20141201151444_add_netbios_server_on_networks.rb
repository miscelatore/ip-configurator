class AddNetbiosServerOnNetworks < ActiveRecord::Migration[4.2]
  def change
    add_column :network, :netbios_name_servers, :string
    add_column :network, :netbios_node_type, :string
  end
end
