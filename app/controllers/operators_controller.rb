class OperatorsController < ApplicationController
  before_action :authenticate_user!
  
  before_action :set_operator, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]
  
  include CommonsControllable

  # GET /operators
  # GET /operators.json
  def index
    if params[:limit_cont].nil?
      params[:limit_cont] = 20
    end
    
    @q = Operator.ransack(search_params)
    @total_result = @q.result().count
    @operators = @q.result().page(params[:page]).per(params[:limit_cont].to_i)
  end
  
  # GET /operators/1
  # GET /operators/1.json
  def show
  end
  
  # GET /operators/new
  def new
   @operator = Operator.new
  end
  
  # POST /operators
  # POST /operators.json
  def create
    @operator = current_user.operators.new(operator_params)

    respond_to do |format|
      if @operator.save
        format.html { redirect_to @operator, notice: t(:operator_created_ok) }
        format.json { render action: 'show', status: :created, location: @operator }
      else
        format.html { render action: 'new' }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operators/1
  # PATCH/PUT /operators/1.json
  def update
    respond_to do |format|
      if @operator.update(operator_params)
        format.html { redirect_to @operator, notice: t(:updated_ok) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @operator.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operators/1
  # DELETE /operators/1.json
  def destroy
    @operator.destroy
    respond_to do |format|
      format.html { redirect_to operators_url }
      format.json { head :no_content }
    end
  end  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operator
      @operator = Operator.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operator_params
      params.require(:operator).permit(:name)
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
