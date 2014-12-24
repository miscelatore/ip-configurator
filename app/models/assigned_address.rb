class AssignedAddress < ActiveRecord::Base
  self.table_name = "assigned_address"
  
  belongs_to :user
  belongs_to :network
  belongs_to :address
  belongs_to :operator
  belongs_to :hardware
  belongs_to :location_port
  
  
  delegate :ip_address, to: :address, prefix: true, allow_nil: true
  
  scope :active, -> { where(enabled: true) }
  
  validates :mac, presence: true, uniqueness: true, format: { with: /([0-9a-f]{2}:){5}[0-9a-f]{2}/ }
  validates :hostname, presence: true, uniqueness: true, format: { with: /[a-z0-9]+(:?[-a-z0-9]*[a-z0-9]+)?/i }
  validates :operator, presence: true
  validates :address, presence: true, uniqueness: true
  validate :address_reserved

  def address_reserved
    errors.add(:address, 'is reserved') if self.address.reserved 
  end
  
  #after_create :upd_dhcp_configuration
  #after_update :upd_dhcp_configuration
  #after_destroy :upd_dhcp_configuration
  
  
  private
  
  def upd_dhcp_configuration
    unless self.last_seen_date.nil?
      Rails.logger.debug("Salvataggio della nuova configurazione!")
      ConfiguratorServices.SaveConfiguration
    end
  end
end
