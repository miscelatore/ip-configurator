class HardwaresController < ApplicationController

  before_action :authenticate_user!
  
  before_action :set_hardware, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  include CommonsControllable
  
  # GET /hardwares
  # GET /hardwares.json
  def index
    if params[:limit_cont].nil?
      params[:limit_cont] = 20
    end
    
    @q = Hardware.ransack(search_params)
    @total_result = @q.result().count
    @hardwares = @q.result().page(params[:page]).per(params[:limit_cont].to_i)
  end
  
  # GET /hardwares/1
  # GET /hardwares/1.json
  def show
  end
  
  # GET /hardwares/new
  def new
   @hardware = Hardware.new
  end
  
  # POST /hardwares
  # POST /hardwares.json
  def create
    #@hardware = Hardware.new(hardware_params)
    @hardware = current_user.hardwares.new(hardware_params)

    respond_to do |format|
      if @hardware.save
        format.html { redirect_to @hardware, notice: t(:hardware_type_created_ok) }
        format.json { render action: 'show', status: :created, location: @hardware }
      else
        format.html { render action: 'new' }
        format.json { render json: @hardware.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hardwares/1
  # PATCH/PUT /hardwares/1.json
  def update
    respond_to do |format|
      if @hardware.update(hardware_params)
        format.html { redirect_to @hardware, notice: t(:hardware_type_updated_ok) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @hardware.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hardwares/1
  # DELETE /hardwares/1.json
  def destroy
    @hardware.destroy
    respond_to do |format|
      format.html { redirect_to hardwares_url }
      format.json { head :no_content }
    end
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware
      @hardware = Hardware.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_params
      params.require(:hardware).permit(:name)
    end
    
    def search_params
      if !params[:q].nil?
            if !params[:q][:name_cont].nil?
               session[:name_cont] = params[:q][:name_cont].to_s
            end
          else
            params[:q] = Hash.new
            params[:q][:name_cont] ||= session[:name_cont]
          end
      
      params[:q]
    end
end
