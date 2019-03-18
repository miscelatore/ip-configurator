class AssignedAddress < ApplicationRecord
  self.table_name = "assigned_address"
  
  belongs_to :user
  belongs_to :address
  belongs_to :operator
  belongs_to :hardware
  # In Rails 5, whenever we define a belongs_to association, it is required to have the associated record present by default after this change.
  # We can pass optional: true to the belongs_to association which would remove this validation check.
  belongs_to :location_port, optional: true
  
  delegate :ip_address, to: :address, prefix: true, allow_nil: true
  
  default_scope -> { order(updated_at: :desc) }
  scope :active, -> { where(enabled: true) }
  scope :no_more_seen, -> { where("last_seen_date < ?", Time.now() - 3.month ) }
  scope :seen_today, -> { where("last_seen_date > ?", Time.now().to_date  ) }
  
  validates :mac, presence: true, uniqueness: true, format: { with: /([0-9a-fA-Z]{2}[:-]){5}[0-9a-fA-Z]{2}/ }
  validates :hostname, presence: true, uniqueness: true, format: { with: /[a-z0-9]+(:?[-a-z0-9]*[a-z0-9]+)?/i }
  
  validates :operator, presence: true
  
  validates :hardware_id, presence: true
  
  validates :address_id, presence: true, uniqueness: true, numericality: { only_integer: true }
  validate :validate_address_id
  
  validates :location_port_id, allow_blank: true, numericality: { only_integer: true }

  #after_create :upd_dhcp_configuration
  #after_update :upd_dhcp_configuration
  #after_destroy :upd_dhcp_configuration
  
  before_save :transform_mac

  
  private
  
    def validate_hardware_id
      errors.add(:hardware_id, I18n.t(:is_invalid)) unless Hardware.exists?(self.hardware_id)
    end
  
    def validate_address_id
      errors.add(:address_id, I18n.t(:is_invalid)) unless Address.exists?(self.address_id)
      errors.add(:address_id, I18n.t(:is_reserved)) if self.address.present? and self.address.reserved 
    end
  
    def transform_mac
       self.mac.downcase!
       self.mac.sub!("-", ":")
    end
  
    def upd_dhcp_configuration
      unless self.last_seen_date.nil?
        Rails.logger.debug("Salvataggio della nuova configurazione!")
        ConfiguratorServices.SaveConfiguration
      end
    end
end
