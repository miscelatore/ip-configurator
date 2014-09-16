class Location < ActiveRecord::Base
  self.table_name = "location"
  
  belongs_to :user
  has_many :location_ports
  accepts_nested_attributes_for :location_ports, reject_if: lambda { |a| a[:name].blank? },  allow_destroy: true

end
