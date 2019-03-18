class AddAssignAdminUserOnAllAssignedAddress < ActiveRecord::Migration[5.2]
  class AssignedAddress < ActiveRecord::Base
    self.table_name = "assigned_address"
  end
  
  def up    
    AssignedAddress.all.each do |aa|
      aa.user_id = 1
      aa.save(validate: false)
    end
  end
  
  def down
    
  end
end
