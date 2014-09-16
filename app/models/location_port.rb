class LocationPort < ActiveRecord::Base
  self.table_name = "location_port"
  
  belongs_to :user
  belongs_to :location
  has_one    :assigned_address
end
