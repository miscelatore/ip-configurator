class UsersController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_hardware, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  def index
    @q = User.search(search_params)
    @q.sorts = 'email' if @q.sorts.empty?
    @users = @q.result().page(params[:page])
  end

  def show
    unless @user == current_user
      redirect_to :back, :alert => "Access denied."
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hardware
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hardware_params
      params.require(:user).permit(:email, :name)
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
