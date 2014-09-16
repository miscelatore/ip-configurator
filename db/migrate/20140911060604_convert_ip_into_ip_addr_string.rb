require 'ip'

class ConvertIpIntoIpAddrString < ActiveRecord::Migration
  
  class Address < ActiveRecord::Base
    self.table_name = "address"
  end
  
  def up
    Address.reset_column_information
    add_column :address, :ip_address, :string
    Address.reset_column_information
    
    Address.all.each do |ip_addr|
      str = IP::V4.new(ip_addr.ip, 32).to_s
      ip_addr.ip_address = str
      ip_addr.save(validate: false)
    end
  end
  
  def down
    remove_column :address, :ip_address
  end
end
