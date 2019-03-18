class Role < ApplicationRecord
  has_and_belongs_to_many :users

  validates :name, uniqueness: true, presence: true
  
  before_save :transform_name
  
  private
    def transform_name
      self.name.capitalize!
    end
end
