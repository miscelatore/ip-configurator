class AddressesController < ApplicationController
  before_action :authenticate_user!
  
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]
  
  include CommonsControllable

  def index
    if params[:limit_cont].nil?
      params[:limit_cont] = 20
    end
    
    @q = Address.ransack(search_params)
    @total_result = @q.result().count
    @addresses = @q.result().page(params[:page]).per(params[:limit_cont].to_i)
  end
  
  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: t(:address_updated_ok) }
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
               session[:ip_address_cont] = params[:q][:ip_address_cont].to_s
            end
            if !params[:q][:network_id_eq].nil?
               session[:network_id_eq] = params[:q][:network_id_eq]
            end
            if !params[:q][:reserved_eq].nil?
               session[:reserved_eq] = params[:q][:reserved_eq]
            end
            if !params[:q][:assigned_address_address_id_present].nil?
               session[:assigned_address_address_id_present] = params[:q][:assigned_address_address_id_present]
            end
          else
            params[:q] = Hash.new
            params[:q][:ip_address_cont]                      ||= session[:ip_address_cont]
            params[:q][:network_id_eq]                        ||= session[:network_id_eq]
            params[:q][:reserved_eq]                          ||= session[:reserved_eq]
            params[:q][:assigned_address_address_id_present]  ||= session[:assigned_address_address_id_present]
          end
      
      params[:q]
    end 
end
