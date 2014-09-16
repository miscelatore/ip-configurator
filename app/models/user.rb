class User < ActiveRecord::Base
  has_and_belongs_to_many :roles
  
  has_many :networks
  has_many :addresses
  has_many :assigned_addresses
  has_many :operators
  has_many :hardwares
  has_many :locations
  has_many :location_ports
    
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def role?(role)
   return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  # validates_presence_of :username
  validates_presence_of :email
  validates :password, :presence     => true, 
                       :confirmation => true,
                       :on => :create
end
