class AddAssignAdminUserOnAllHardware < ActiveRecord::Migration[5.2]
  class Hardware < ActiveRecord::Base
    self.table_name = "hardware"
  end
  
  def up    
    Hardware.all.each do |hw|
      hw.user_id = 1
      hw.save(validate: false)
    end
  end
  
  def down
    
  end
end
