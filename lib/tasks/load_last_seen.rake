# To run this script execute via command line from the root path of the project: rake update_last_seen_ip

desc "Update last seen IP timestamps."
  task :update_last_seen_ip => :environment do
    #Rails.logger = Logger.new(STDOUT)
    Rails.logger.info("Running update_last_seen_ip task!")
    File.open("#{Rails.application.config.dhcp_logfile}", "r").each do |line|
      if line.match(/.+\s+dhcpd:\s+DHCPACK\s+on\s+([\d\.]+)\s+to\s+([a-f0-9\:]+)\s+via\s+eth\d/i) 
        month, day, time, hostname, service, action, ignore_on, ip_addr, ignore_to, mac_address, ignore_via, device = line.strip.split(" ")
        addr = AssignedAddress.find_by_mac(mac_address)
        unless addr.nil?
          t_line_datetime = "#{month} #{day} #{time}"
          last_seen_date = DateTime.parse(t_line_datetime)
          if addr.last_seen_date.nil? || addr.last_seen_date < last_seen_date
            Rails.logger.debug("Update filed last_seen_date!")
            Rails.logger.debug("IP: #{ip_addr}")
            Rails.logger.debug("MAC: #{mac_address}")
            Rails.logger.debug("Operator: #{addr.operator.name}")
            Rails.logger.debug("DateTime logfile: #{t_line_datetime}")
            Rails.logger.debug("DateTime: #{last_seen_date}")
            Rails.logger.debug('----------------')
            addr.update_attribute(:last_seen_date, last_seen_date)
          end
        end
      end
    end
  end