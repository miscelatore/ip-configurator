class LocationPort < ApplicationRecord
  self.table_name = "location_port"
  
  belongs_to :user
  belongs_to :location, inverse_of: :location_ports
  has_one    :assigned_address
  
  scope :sorted, -> { order(:location_id, :name) }
  
  def toString
    return "#{self.location.name} - #{name}"
  end
  
end
