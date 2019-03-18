class Location < ApplicationRecord
  self.table_name = "location"
  
  belongs_to :user
  has_many :location_ports, inverse_of: :location, dependent: :destroy
  
  accepts_nested_attributes_for :location_ports, reject_if: proc { |attributes| attributes[:name].blank? }, allow_destroy: true
  
  default_scope -> { order(:name) }
  scope :sorted, -> { order(:name) }
  
  validates :name, presence: true

end
