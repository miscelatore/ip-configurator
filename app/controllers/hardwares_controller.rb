class HardwaresController < ApplicationController

  before_filter :authenticate_user!
  
  before_action :set_hardware, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  # GET /hardwares
  # GET /hardwares.json
  def index
    @q = Hardware.search(search_params)
    @q.sorts = 'name' if @q.sorts.empty?
    @hardwares = @q.result().page(params[:page])
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
    @hardware = Hardware.new(hardware_params)

    respond_to do |format|
      if @hardware.save
        format.html { redirect_to @hardware, notice: 'Hardware was successfully created.' }
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
        format.html { redirect_to @hardware, notice: 'Hardware was successfully updated.' }
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
               session[:name] = params[:q][:name_cont].to_s
            end
          else
            params[:q] = Hash.new
            params[:q][:name_cont] ||= session[:name]
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
