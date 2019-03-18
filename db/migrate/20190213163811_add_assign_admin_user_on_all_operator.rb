class AddAssignAdminUserOnAllOperator < ActiveRecord::Migration[5.2]

  class Operator < ActiveRecord::Base
    self.table_name = "operator"
  end
  
  def up    
    Operator.all.each do |op|
      op.user_id = 1
      op.save(validate: false)
    end
  end
  
  def down
    
  end
  
end
