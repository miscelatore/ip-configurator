class RolesController < ApplicationController
  before_action :authenticate_user!
  
  before_action :set_role, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  def index
    @q = Role.ransack(search_params)
    @q.sorts = 'name' if @q.sorts.empty?
    @roles = @q.result().page(params[:page])
  end

  def show
  end
  
  
  def new
    @role = Role.new
  end
  
  
  # GET /roles/1/edit
  def edit
  end
  
  
  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render action: 'show', status: :created, location: @role }
      else
        format.html { render action: 'new' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update

    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url }
      format.json { head :no_content }
    end
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name)
    end
    
    def search_params
      if !params[:q].nil?
        if !params[:q][:name_cont].nil?
           session[:name] = params[:q][:name_cont].to_s
        end
      else
          params[:q] = Hash.new
          params[:q][:name_cont]  ||= session[:name]
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
