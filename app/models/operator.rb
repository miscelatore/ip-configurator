class Operator < ActiveRecord::Base
  self.table_name = "operator"
  
   belongs_to :user
   has_many :assigned_addresses
   
   scope :sorted, -> { order(:name) }

   validates :name, presence: true
end
