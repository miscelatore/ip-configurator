class LocationsController < ApplicationController

  before_filter :authenticate_user!
  
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  # GET /locations
  # GET /locations.json
  def index
    @q = Location.search(search_params)
    @q.sorts = 'name' if @q.sorts.empty?
    @locations = @q.result().page(params[:page])
  end
  
  # GET /locations/1
  # GET /locations/1.json
  def show
  end
  
  # GET /locations/new
  def new
   @location = Location.new
  end
  
  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @location }
      else
        format.html { render action: 'new' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.    
    def location_params
      params.require(:location).permit(
        :name,
        location_ports_attributes: [:id, :location_id, :name, :_destroy])
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
