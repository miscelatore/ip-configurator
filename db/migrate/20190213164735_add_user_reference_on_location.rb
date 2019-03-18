class AddUserReferenceOnLocation < ActiveRecord::Migration[5.2]
  class Location < ActiveRecord::Base
    self.table_name = "location"
  end
  
  def change
    add_reference :location, :user, index: true, foreign_key: true
    
    Location.all.each do |lc|
      lc.user_id = 1
      lc.save(validate: false)
    end
  end
end
