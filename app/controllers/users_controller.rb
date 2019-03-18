class UsersController < ApplicationController
  before_action :authenticate_user!
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  def index
    @q = User.ransack(search_params)
    @q.sorts = 'email' if @q.sorts.empty?
    @users = @q.result().page(params[:page])
  end

  def show
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end
  
  
  def new
    @user = User.new
  end
  
  
  # GET /users/1/edit
  def edit
  end
  
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role_ids => [])
    end
    
    def search_params
      if !params[:q].nil?
        if !params[:q][:email_cont].nil?
           session[:email] = params[:q][:email_cont].to_s
        end
        if !params[:q][:name_cont].nil?
           session[:name] = params[:q][:name_cont].to_s
        end
      else
          params[:q] = Hash.new
          params[:q][:email_cont] ||= session[:email]
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
