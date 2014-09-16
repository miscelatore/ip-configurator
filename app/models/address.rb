require 'ip'

class Address < ActiveRecord::Base
  self.table_name = "address"
  
  belongs_to :user
  belongs_to :network
  has_one    :assigned_address, dependent: :destroy
  
  scope :sorted, -> { order(:network_id, :value) }
  
  validates :ip_address, uniqueness: true
  validates :network, presence: true
  validate :address_assigned

  def address_assigned
    errors.add(:address, 'is assigned') if self.assigned_address
  end
  
  #TODO: definire in callbacks per popolare il campo value con l'ultimo ottetto dell'IP address
  before_save :make_value
  
  
  
  # #getter
  # def ip_addr
  #   @ip_addr || IP::V4.new(ip, 32).to_s
  # end
  # 
  # #setter
  # def ip_addr=(value)
  #   addr = IP.new("#{value}/32")
  #   self.ip = addr.to_hex
  # end
  
  def is_assigned?
    self.assigned_address
  end
  
  
  def toString
    if self.assigned_address
      return "#{ip_address} (assegnato)"
    elsif self.reserved
      return "#{ip_address} (riservato)"
    else
      return "#{ip_address}"
    end
  end
  
  private
  
  def make_value
    if self.changed?
      t_ip = ip_address.split(/\./)
      self.value = t_ip[3]
    end
  end
  
end
