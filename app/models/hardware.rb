class Hardware < ActiveRecord::Base
  self.table_name = "hardware"
  
  belongs_to :user
  has_many :assigned_addresses
  
  scope :sorted, -> { order(:name) }
  
  validates :name, presence: true
end
