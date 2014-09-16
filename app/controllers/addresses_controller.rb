class AddressesController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  def index
    @q = Address.search(search_params)
    @q.sorts = 'network_id, value' if @q.sorts.empty?
    @addresses = @q.result().page(params[:page])
  end
  
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:ip_address, :reserved, :value, :network_id)
    end
    
    def search_params
      if !params[:q].nil?
            if !params[:q][:ip_address_cont].nil?
               session[:ip_address] = params[:q][:ip_address_cont].to_s
            end
            if !params[:q][:network_id_eq].nil?
               session[:network_id] = params[:q][:network_id_eq]
            end
            if !params[:q][:reserved_eq].nil?
               session[:reserved] = params[:q][:reserved_eq]
            end
            if !params[:q][:assigned_address_address_id_present].nil?
               session[:assigned_address_address_id] = params[:q][:assigned_address_address_id_present]
            end
          else
            params[:q] = Hash.new
            params[:q][:ip_address_cont]                      ||= session[:ip_address]
            params[:q][:network_id_eq]                        ||= session[:network_id]
            params[:q][:reserved_eq]                          ||= session[:reserved]
            params[:q][:assigned_address_address_id_present]  ||= session[:assigned_address_address_id]
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
