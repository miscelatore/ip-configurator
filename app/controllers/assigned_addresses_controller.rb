class AssignedAddressesController < ApplicationController

  before_action :authenticate_user!
  
  autocomplete :address, :ip_address, :full => true, :display_value => :toString, :extra_data => [:reserved], :scopes => [:sorted], :limit => 20
  
  before_action :get_assigned_address, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]
  
  include CommonsControllable

  # GET /assigned_addresses
  # GET /assigned_addresses.json
  def index
    if params[:limit_cont].nil?
      params[:limit_cont] = 20
    end
    
    @q = AssignedAddress.ransack(search_params)
    @total_result = @q.result().count
    @assigned_addresses = @q.result().page(params[:page]).per(params[:limit_cont].to_i)
  end
  
  # GET /assigned_addresses/1
  # GET /assigned_addresses/1.json
  def show
	respond_to do |format|
		format.html
		format.json { render json: @assigned_address } 
	end
  end
  
  # GET /assigned_addresses/new
  def new
   @assigned_address = AssignedAddress.new
  end
  
  # POST /assigned_addresses
  # POST /assigned_addresses.json
  def create
    @assigned_address = current_user.assigned_addresses.new(assigned_address_params)

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
    def get_assigned_address
      @assigned_address = AssignedAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assigned_address_params
      params.require(:assigned_address).permit(:description, :enabled, :hostname, :mac, :address_id, :hardware_id, :operator_id, :location_port_id, :last_seen_date)
    end
    
    def search_params
      if !params[:q].nil?
            if !params[:q][:hostname_cont].nil?
               session[:hostname_cont] = params[:q][:hostname_cont].to_s
            end
            if !params[:q][:mac_cont].nil?
               session[:mac_cont] = params[:q][:mac_cont].to_s
            end
            if !params[:q][:address_ip_address_cont].nil?
               session[:address_ip_address_cont] = params[:q][:address_ip_address_cont]
            end
            if !params[:q][:operator_name_cont].nil?
               session[:operator_name_cont] = params[:q][:operator_name_cont]
            end
            if !params[:q][:hardware_id_eq].nil?
               session[:hardware_id_eq] = params[:q][:hardware_id_eq]
            end
            if !params[:q][:enabled_eq].nil?
               session[:enabled_eq] = params[:q][:enabled_eq]
            end
            if !params[:q][:description_cont].nil?
               session[:description_cont] = params[:q][:description_cont].to_s
            end
            if !params[:q][:last_seen_date_lteq].nil?
               session[:last_seen_date_lteq] = params[:q][:last_seen_date_lteq]
            end
            if !params[:q][:last_seen_date_gteq].nil?
               session[:last_seen_date_gteq] = params[:q][:last_seen_date_gteq]
            end
          else
            params[:q] = Hash.new
            params[:q][:hostname_cont]            ||= session[:hostname_cont]
            params[:q][:mac_cont]                 ||= session[:mac_cont]
            params[:q][:address_ip_address_cont]  ||= session[:address_ip_address_cont]
            params[:q][:operator_name_cont]       ||= session[:operator_name_cont]
            params[:q][:hardware_id_eq]           ||= session[:hardware_id_eq]
            params[:q][:enabled_eq]               ||= session[:enabled_eq]
            params[:q][:description_cont]         ||= session[:description_cont]
            params[:q][:last_seen_date_lteq]      ||= session[:last_seen_date_lteq]
            params[:q][:last_seen_date_gteq]      ||= session[:last_seen_date_gteq]
          end
      
      params[:q]
    end
        
end
