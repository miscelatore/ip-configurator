class Operator < ApplicationRecord
  self.table_name = "operator"
  
   belongs_to :user
   has_many :assigned_addresses
   
   default_scope -> { order(:name) }
   scope :sorted, -> { order(:name) }

   validates :name, presence: true
end
