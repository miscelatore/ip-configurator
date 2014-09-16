class Operator < ActiveRecord::Base
  self.table_name = "operator"
  
   belongs_to :user
   has_many :assigned_addresses
end
