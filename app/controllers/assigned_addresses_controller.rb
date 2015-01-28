class AssignedAddressesController < ApplicationController

  before_filter :authenticate_user!
  
  autocomplete :address, :ip_address, :full => true, :display_value => :toString, :extra_data => [:reserved], :scopes => [:sorted], :limit => 20
  
  before_action :set_assigned_address, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]
  
  

  # GET /assigned_addresses
  # GET /assigned_addresses.json
  def index
    @q = AssignedAddress.search(search_params)
    @q.sorts = 'updated_at' if @q.sorts.empty?
    @assigned_addresses = @q.result().page(params[:page])
  end
  
  # GET /assigned_addresses/1
  # GET /assigned_addresses/1.json
  def show
  end
  
  # GET /assigned_addresses/new
  def new
   @assigned_address = AssignedAddress.new
  end
  
  # POST /assigned_addresses
  # POST /assigned_addresses.json
  def create
    @assigned_address = AssignedAddress.new(assigned_address_params)

    respond_to do |format|
      if @assigned_address.save
        format.html { redirect_to @assigned_address, notice: 'AssignedAddress was successfully created.' }
        format.json { render action: 'show', status: :created, location: @assigned_address }
      else
        format.html { render action: 'new' }
        format.json { render json: @assigned_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assigned_addresses/1
  # PATCH/PUT /assigned_addresses/1.json
  def update
    respond_to do |format|
      if @assigned_address.update(assigned_address_params)
        format.html { redirect_to @assigned_address, notice: 'AssignedAddress was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @assigned_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assigned_addresses/1
  # DELETE /assigned_addresses/1.json
  def destroy
    @assigned_address.destroy
    respond_to do |format|
      format.html { redirect_to assigned_addresses_url }
      format.json { head :no_content }
    end
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assigned_address
      @assigned_address = AssignedAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_address_params
      params.require(:assigned_address).permit(:description, :enabled, :hostname, :mac, :address_id, :hardware_id, :operator_id, :location_port_id, :last_seen_date)
    end
    
    def search_params
      if !params[:q].nil?
            if !params[:q][:hostname_cont].nil?
               session[:hostname] = params[:q][:hostname_cont].to_s
            end
            if !params[:q][:mac_cont].nil?
               session[:mac] = params[:q][:mac_cont].to_s
            end
            if !params[:q][:address_ip_address_cont].nil?
               session[:address] = params[:q][:address_ip_address_cont]
            end
            if !params[:q][:operator_name_cont].nil?
               session[:operator] = params[:q][:operator_name_cont]
            end
            if !params[:q][:hardware_id_eq].nil?
               session[:hardware_id] = params[:q][:hardware_id_eq]
            end
            if !params[:q][:enabled_eq].nil?
               session[:enabled] = params[:q][:enabled_eq]
            end
            if !params[:q][:description_cont].nil?
               session[:description] = params[:q][:description_cont].to_s
            end
            if !params[:q][:last_seen_date_lteq].nil?
               session[:last_seen_date_before] = params[:q][:last_seen_date_lteq]
            end
            if !params[:q][:last_seen_date_gteq].nil?
               session[:last_seen_date_after] = params[:q][:last_seen_date_gteq]
            end
          else
            params[:q] = Hash.new
            params[:q][:hostname_cont]            ||= session[:hostname]
            params[:q][:mac_cont]                 ||= session[:mac]
            params[:q][:address_ip_address_cont]  ||= session[:address]
            params[:q][:operator_name_cont]       ||= session[:operator]
            params[:q][:hardware_id_eq]           ||= session[:hardware_id]
            params[:q][:enabled_eq]               ||= session[:enabled]
            params[:q][:description_cont]         ||= session[:description]
            params[:q][:last_seen_date_lteq]      ||= session[:last_seen_date_before]
            params[:q][:last_seen_date_gteq]      ||= session[:last_seen_date_after]
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
