# To run this script execute via command line from the root path of the project: rake update_last_seen_ip

desc "Update last seen IP timestamps."
  task :update_last_seen_ip => :environment do
    #Rails.logger = Logger.new(STDOUT)
    Rails.logger.info("Start Running update_last_seen_ip task!")
    File.open("#{Rails.application.config.dhcp_logfile}", "r").each do |line|
      #	Dec 12 09:56:17 monitor dhcpd: DHCPACK on 192.12.193.49 to 6c:62:6d:50:fc:b0 via eth1
      # Dopo aggiornamento alla versione Ubuntu 16.04.02
      # May  3 06:25:32 dhcp-r1 dhcpd[2691]: DHCPACK on 192.168.17.131 to a0:d3:c1:ed:8d:66 via enp4s0f1
      if line.match(/.+\s+dhcpd\[\d+\]:\s+DHCPACK\s+on\s+([\d+\.]+)\s+to\s+([a-f0-9\:]+)\s+via\s+.+/i) 
        month, day, time, hostname, service, action, ignore_on, ip_addr, ignore_to, mac_address, ignore_via, device = line.strip.split(" ")
        #Rails.logger.info("mac_address: #{mac_address}")
        addr = AssignedAddress.find_by_mac(mac_address)
        #Rails.logger.info("addr: #{addr}")
        unless addr.nil?
          t_line_datetime = "#{month} #{day} #{time}"
          # last_seen_date = DateTime.parse(t_line_datetime)
	  last_seen_date = ActiveSupport::TimeZone['Europe/Rome'].parse(t_line_datetime)
          #Rails.logger.info("addr presente")
          #Rails.logger.info("addr: #{addr} last_seen_date: #{last_seen_date} :: time.now: #{Time.now()}" )
          #Rails.logger.info("addr presente")
          if last_seen_date <= Time.now()
           #Rails.logger.info("addr.last_seen_date: #{addr.last_seen_date} :: last_seen_date: #{last_seen_date}" )
           if addr.last_seen_date.nil? || addr.last_seen_date < last_seen_date
            #Rails.logger.info("Update field last_seen_date!")
            Rails.logger.info("  last_seen_date :: IP: #{ip_addr} MAC: #{mac_address} Operator: #{addr.operator.name} DateTime: #{last_seen_date}")
            #Rails.logger.info("MAC: #{mac_address}")
            #Rails.logger.info("Operator: #{addr.operator.name}")
            #Rails.logger.info("DateTime logfile: #{t_line_datetime}")
            #Rails.logger.info("DateTime: #{last_seen_date}")
            #Rails.logger.info('----------------')
            addr.update_attribute(:last_seen_date, last_seen_date)
           end
          end
        end
      end
    end
    Rails.logger.info("End Running update_last_seen_ip task!")
  end
