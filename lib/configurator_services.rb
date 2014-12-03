require 'fileutils'

class ConfiguratorServices
  def self.SaveConfiguration
    
    datetime_dhcp_version = Time.now.strftime("%Y%m%d%H%M%S").to_s
    dhcp_file = Rails.application.config.dhcp_file
    dhcp_file_tmp = Rails.application.config.dhcp_file + '.temp'
    dhcp_file_bkp = Rails.application.config.dhcp_file + '.' + datetime_dhcp_version
  
    datetime_dhcp_version = Time.now.strftime("%Y%m%d%H%M%S").to_s
  
    exit_code = 0
    

    #------------------------------------------
    # Generazione configurazione dhcp e 
    # porzioni di zone dirette ed inverse
    #------------------------------------------
    new_dhcp_config = "# autogenerated by ip-configurator #{datetime_dhcp_version}\n\n"
    new_dhcp_config << "shared-network registry {\n\n"
    
    dhcp_networks = Network.all.enabled
    
    dhcp_networks.each do |n|
      Rails.logger.debug("Generate subnet configuration for #{n.start_address}")
      new_dhcp_config << "subnet " + n.start_address + " netmask " + n.netmask + " {\n"
      new_dhcp_config << "  option routers " + n.gateway + ";\n"
      new_dhcp_config << "  option subnet-mask " + n.netmask + ";\n"
      new_dhcp_config << "  option domain-name-servers " + n.server_dns + ";\n"
      new_dhcp_config << "  option domain-name \"" + n.dns_zone + "\";\n"
      if !n.netbios_name_servers.nil?
        new_dhcp_config << "  option netbios-name-servers " + n.netbios_name_servers + ";\n"
        new_dhcp_config << "  option netbios-node-type " + n.netbios_node_type + ";\n"
      end
      new_dhcp_config << "  default-lease-time " + n.default_lease_time + ";\n"
      new_dhcp_config << "  max-lease-time " + n.max_lease_time + ";\n"
      new_dhcp_config << "}\n\n"
    end
    new_dhcp_config << "}\n\n"
    
    dhcp_addresses = AssignedAddress.find_by_sql("SELECT * from assigned_address 
                INNER JOIN address ON assigned_address.address_id = address.id 
                INNER JOIN network ON address.network_id = network.id 
                WHERE network.dhcp_enabled is true AND assigned_address.enabled is true 
                ORDER by network.start_address DESC, address.ip ASC" )
                
    # #  Daniele Vannozzi hp2420-a23
    # #  stampante ex marconi
    # host 192.168.17.129 {
    #   hardware ethernet 00:12:79:e0:6a:71;
    #   fixed-address 192.168.17.129;
    # }            
    
    new_rev_zones = Hash.new
    new_rr_zones = Hash.new
    
    dhcp_addresses.each do |a|
      Rails.logger.debug("Generate host configuration for #{a.address.ip_address}")
      new_dhcp_config << "#  " + "#{a.operator.name}" + " " + "#{a.hostname}" + "\n"
      new_dhcp_config << "#  " + "#{a.description ||= ''}" + "\n"
      new_dhcp_config << "host " + a.address.ip_address + " {\n"
      new_dhcp_config << "  hardware ethernet " + a.mac + ";\n"
      new_dhcp_config << "  fixed-address " + a.address.ip_address + ";\n"
      new_dhcp_config << "}\n\n"
      
      unless a.hostname.nil?
        # RR risoluzione inversa
        unless new_rev_zones.has_key?("#{a.address.network.start_address}") 
          new_rev_zones["#{a.address.network.start_address}"] ||= "#{a.address.value}\tPTR\t#{a.hostname}.#{a.network.dns_zone}.\n" 
        else
          new_rev_zones["#{a.address.network.start_address}"] += "#{a.address.value}\tPTR\t#{a.hostname}.#{a.network.dns_zone}.\n"
        end
        
        # RR risoluzione diretta
        unless new_rr_zones.has_key?("#{a.address.network.dns_zone}") 
          new_rr_zones["#{a.address.network.dns_zone}"] ||= "#{a.hostname}\tIN\tA\t#{a.address.ip_address}\n" 
        else
          new_rr_zones["#{a.address.network.dns_zone}"] += "#{a.hostname}\tIN\tA\t#{a.address.ip_address}\n"
        end
      end 
    end
    
    begin
      #------------------------------------------------
      # Creazione file configurazione dhcp
      #------------------------------------------------
      File.open(dhcp_file_tmp, 'w') do |f|
        f.write("#{new_dhcp_config}")
      end
      
      #------------------------------------------------
      # Generazione files di zona: risoluzione inversa
      #------------------------------------------------
      #new_rev_zones.each {|key, value| Rails.logger.debug("#{key} is #{value}") }
      new_rev_zones.each_key {|key| 
        Rails.logger.debug("#{key}")
        
        file_rev_zone_tmp = 'tmp/' + key + '.rev.temp'
        File.open(file_rev_zone_tmp, 'w') do |f|
          f.write("#{new_rev_zones.fetch("#{key}")}")
        end
        
        file_rev_zone_bkp = 'tmp/' + key + '.rev.' + datetime_dhcp_version
        file_rev_zone = 'tmp/' + key + '.rev'
        
        if File.exist?(file_rev_zone)
          Rails.logger.info("Move previous rev zone file : #{file_rev_zone} file into production file: #{file_rev_zone_bkp}")
          FileUtils.move(file_rev_zone, file_rev_zone_bkp)
        end
        Rails.logger.info("Move new rev zone file : #{file_rev_zone_tmp} file into production file: #{file_rev_zone}") 
        FileUtils.move(file_rev_zone_tmp, file_rev_zone)  
      }
      
      #------------------------------------------------
      # Generazione files di zona: risoluzione diretta
      #------------------------------------------------
      #new_rr_zones.each {|key, value| Rails.logger.debug("#{key} is #{value}") }
      new_rr_zones.each_key {|key| 
        Rails.logger.debug("#{key}")
        
        file_dir_zone_tmp = 'tmp/' + key + '.dir.temp'
        File.open(file_dir_zone_tmp, 'w') do |f|
          f.write("#{new_rr_zones.fetch("#{key}")}")
        end
        
        file_dir_zone_bkp = 'tmp/' + key + '.dir.' + datetime_dhcp_version
        file_dir_zone = 'tmp/' + key + '.dir'
        
        if File.exist?(file_dir_zone)
          Rails.logger.info("Move previous dir zone file : #{file_dir_zone} file into production file: #{file_dir_zone_bkp}")
          FileUtils.move(file_dir_zone, file_dir_zone_bkp)
        end
        Rails.logger.info("Move new dir zone file : #{file_dir_zone_tmp} file into production file: #{file_dir_zone}") 
        FileUtils.move(file_dir_zone_tmp, file_dir_zone)
      }
      
      if File.exist?(dhcp_file)
        Rails.logger.info("Move previous config file : #{dhcp_file} file into production file: #{dhcp_file_bkp}")
        FileUtils.move(dhcp_file, dhcp_file_bkp)
      end
      Rails.logger.info("Move new config file : #{dhcp_file_tmp} file into production file: #{dhcp_file}") 
      FileUtils.move(dhcp_file_tmp, dhcp_file)
      
      rescue Timeout::Error => e
        exit_code = 1
        Rails.logger.info("Time out command: #{e}")
        #raise e
      rescue Errno::ENOENT => e
        exit_code = 1
        Rails.logger.info("Exception ENOENT occurred: #{e}")
        #raise e
      rescue Errno::EPERM => e
        exit_code = 1
        Rails.logger.info("Exception EPERM occurred: #{e}")
        #raise e  
      rescue Exception => e
        exit_code = 1
        Rails.logger.info("Exception occured: #{e}")
        #raise e
    end
    
    Rails.logger.debug("SaveConfiguration exit code: #{exit_code}")
   
    
    return exit_code
  
  end
  
  
  def self.RestartDhcpd
        
    Rails.logger.debug("Restarting DHCPD service")
    
    exit_code = 0
    output_result = nil
      
    begin
      Rails.logger.info("#{Rails.application.config.dhcpRestartCommand}")    
      
      output_result = `#{Rails.application.config.dhcpRestartCommand}`
      Rails.logger.info("Done!")
      
      rescue SystemCallError => e
        exit_code = 1
        Rails.logger.info("Command couldn’t execute: #{e}")
        #raise e
      rescue Exception => e
        exit_code = 1
        Rails.logger.info("EXCEPTION: #{e}")
        #raise e
    end
  
    Rails.logger.debug("RestartDhcpd exit code: #{exit_code}")

    return exit_code
     
  end  
  
  
end