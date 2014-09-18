class DhcpCommandsController < ApplicationController
  #authorize_resource class: false
  before_filter :authenticate_user!
  
  def make_conf
    logger.debug("Make new DHCP configuration")
    
    respond_to do |format|
      if ConfiguratorServices.SaveConfiguration == 0
        format.html { redirect_to root_path, notice: 'DHCP configuration was successfully created.' }
        #format.json { render action: 'show', status: :created, location: root_path }
      else
        format.html { redirect_to root_path, alert: 'DHCP configuration was unsuccessfully created. See logfile for details.' }
        #format.json { render json: root_path.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def restart_service
    logger.debug("restart_service :: Restarting DHCP service")
    respond_to do |format|
      if ConfiguratorServices.RestartDhcpd == 0
        format.html { redirect_to root_path, notice: 'DHCP service was successfully restartd.' }
        #format.json { render action: 'show', status: :created, location: root_path }
      else
        format.html { redirect_to root_path, alert: 'Error restarting DHCP service. See logfile for details' }
        #format.json { render json: visitors_path.errors, status: :unprocessable_entity }
      end
    end
  end
end
