class OperatorsController < ApplicationController
  before_filter :authenticate_user!
  
  before_action :set_operator, only: [:show, :edit, :update, :destroy]
  before_action :clear_search_index, only: [:index]

  # GET /operators
  # GET /operators.json
  def index
    @q = Operator.search(search_params)
    @q.sorts = 'name' if @q.sorts.empty?
    @operators = @q.result().page(params[:page])
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
    @operator = Operator.new(operator_params)

    respond_to do |format|
      if @operator.save
        format.html { redirect_to @operator, notice: 'Operator was successfully created.' }
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
        format.html { redirect_to @operator, notice: 'Operator was successfully updated.' }
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
