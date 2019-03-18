require 'ip'
require 'resolv'

class NameserversValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    value.split(/\,\s*/).each do |ns|
      unless ns =~ (Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex))
        record.errors[attribute] << (options[:message] || "is not a valid IPaddr format")
      end
    end
  end
end

class DomainNameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A(?:[-a-z0-9]+\.)+[a-z]{2,}\z/i
      record.errors[attribute] << (options[:message] || "is not a valid damain name")
    end
  end
end

class Network < ApplicationRecord
  self.table_name = "network"
  
  belongs_to :user
  has_many :addresses, dependent: :destroy
  
  default_scope -> { order(:start_address) }
  scope :sorted, -> { order(:start_address) }
  scope :enabled, -> { where(dhcp_enabled: true) }
  
  validates :name, presence: true, uniqueness: true
  validates :start_address, presence: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), message: "Not a valid IPaddr format"}
  validates :space, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 256, even: true, only_integer: true }
  validates :gateway, presence: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), message: "Not a valid IPaddr format"}
  validates :netmask, presence: true, format: { with: /\A(((128|192|224|240|248|252|254)\.0\.0\.0)|(255\.(0|128|192|224|240|248|252|254)\.0\.0)|(255\.255\.(0|128|192|224|240|248|252|254)\.0)|(255\.255\.255\.(0|128|192|224|240|248|252|254)))\z/i }
  validates :server_dns, presence: true, nameservers: true
  validates :dns_zone, presence: true, domain_name: true
  validates :netbios_name_servers, allow_blank: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), message: "Not a valid IPaddr format"}
  validates :netbios_node_type, inclusion: { in: %w(1 2 4 8) }, presence: true, unless: -> { self.netbios_name_servers.blank? }
  validates :ntp_servers, allow_blank: true, format: { with: Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex), message: "Not a valid IPaddr format"}
  
  after_create :create_addresses
  after_update :upd_dhcp_configuration
  
  # TODO: update of addresses by before_update callbacks
  
  
  private
  
  def create_addresses
    (0..space-1).each do |value|
       if value == 0 || value == (space - 1)
         reserved = true
       else
         reserved = false
       end
       Address.create! do |a|
        a.value = value
        a.network = self
        a.reserved = reserved
        addr = IP.new("#{self.start_address}/#{get_pref(self.netmask)}")
        a.ip = (addr + value).to_hex
        a.ip_address = (addr + value).to_addr
       end
    end
  end
  
  
  def upd_dhcp_configuration
    ConfiguratorServices.SaveConfiguration
  end
  
  
  def get_pref(netmask)
      case netmask
      when '255.255.255.255'
        return '32'
      when '255.255.255.254'
        return '31'
      when '255.255.255.252'
        return '30'
      when '255.255.255.248'
        return '29'
      when '255.255.255.240'
        return '28'
      when '255.255.255.224'
        return '27'
      when '255.255.255.192'
        return '26'
      when '255.255.255.128'
        return '25'
      when '255.255.255.0'
        return '24'
      when '255.255.254.0'
        return '23'
      when '255.255.252.0'
        return '22'
      when '255.255.248.0'
        return '21'
      when '255.255.240.0'
        return '20'
      when '255.255.224.0'
        return '19'
      when '255.255.192.0'
        return '18'
      when '255.255.128.0'
        return '17'
      when '255.255.0.0'
        return '16'
      when '255.254.0.0'
        return '15'
      when '255.252.0.0'
        return '14'
      when '255.248.0.0'
        return '13'
      when '255.240.0.0'
        return '12'
      when '255.224.0.0'
        return '11'
      when '255.192.0.0'
        return '10'
      when '255.128.0.0'
        return '9'
      when '255.0.0.0'
        return '8'
      when '254.0.0.0'
        return '7'
      when '252.0.0.0'
        return '6'
      when '248.0.0.0'
        return '5'
      when '240.0.0.0'
        return '4'
      when '224.0.0.0'
        return '3'
      when '192.0.0.0'
        return '2'
      else
        return '24'
      end
  end
  
end
