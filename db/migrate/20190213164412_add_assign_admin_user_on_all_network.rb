class AddAssignAdminUserOnAllNetwork < ActiveRecord::Migration[5.2]
  class Network < ActiveRecord::Base
    self.table_name = "network"
  end
  
  def up    
    Network.all.each do |nw|
      nw.user_id = 1
      nw.save(validate: false)
    end
  end
  
  def down
    
  end
end
