class AddAssignAdminUserOnAllAddress < ActiveRecord::Migration[5.2]
  class Address < ActiveRecord::Base
    self.table_name = "address"
  end
  
  def up    
    Address.all.each do |hd|
      hd.user_id = 1
      hd.save(validate: false)
    end
  end
  
  def down
  end
end
