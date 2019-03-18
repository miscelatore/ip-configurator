class Hardware < ApplicationRecord
  self.table_name = "hardware"
  
  belongs_to :user
  has_many :assigned_addresses
  
  default_scope -> { order(:name) }
  scope :sorted, -> { order(:name) }
  
  validates :name, presence: true
end
