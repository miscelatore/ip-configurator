class NetworksController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_network, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  # GET /networks
  # GET /networks.json
  def index
    @q = Network.search(search_params)
    @q.sorts = 'start_address' if @q.sorts.empty?
    @networks = @q.result().page(params[:page])
  end
  
  # GET /networks/1
  # GET /networks/1.json
  def show
  end
  
  # GET /networks/new
  def new
   @network = Network.new
  end
  
  # POST /networks
  # POST /networks.json
  def create
    @network = Network.new(network_params)

    respond_to do |format|
      if @network.save
        format.html { redirect_to @network, notice: 'Network was successfully created.' }
        format.json { render action: 'show', status: :created, location: @network }
      else
        format.html { render action: 'new' }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /networks/1
  # PATCH/PUT /networks/1.json
  def update
    respond_to do |format|
      if @network.update(network_params)
        format.html { redirect_to @network, notice: 'Network was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /networks/1
  # DELETE /networks/1.json
  def destroy
    @network.destroy
    respond_to do |format|
      format.html { redirect_to networks_url }
      format.json { head :no_content }
    end
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_network
      @network = Network.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def network_params
      params.require(:network).permit(:name, :dhcp_enabled, :gateway, :netmask, :server_address, 
                                      :space, :start_address, :dns_zone, :server_dns, :pxefile, 
                                      :default_lease_time, :max_lease_time, :netbios_name_servers, 
                                      :netbios_node_type)
    end

    def search_params
      if !params[:q].nil?
            if !params[:q][:name_cont].nil?
               session[:name] = params[:q][:name_cont].to_s
            end
            if !params[:q][:start_address_cont].nil?
               session[:start_address] = params[:q][:start_address_cont]
            end
            if !params[:q][:dhcp_enabled_eq].nil?
               session[:dhcp_enabled] = params[:q][:dhcp_enabled_eq]
            end
          else
            params[:q] = Hash.new
            params[:q][:name_cont]            ||= session[:name]
            params[:q][:start_address_cont]   ||= session[:start_address]
            params[:q][:dhcp_enabled_eq]      ||= session[:dhcp_enabled]
          end
      
      params[:q]
    end

    def clear_search_index
      if params[:search_cancel]
        params.delete(:search_cancel)
        if(!search_params.nil?)
          search_params.each do |key, param|
            search_params[key] = nil
          end
        end
      end
    end
end
