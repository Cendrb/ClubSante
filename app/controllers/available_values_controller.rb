class AvailableValuesController < ApplicationController
  before_action :set_available_value, only: [:show, :edit, :update, :destroy]

  # GET /available_values
  # GET /available_values.json
  def index
    @available_values = AvailableValue.all
  end

  # GET /available_values/1
  # GET /available_values/1.json
  def show
  end

  # GET /available_values/new
  def new
    @available_value = AvailableValue.new
  end

  # GET /available_values/1/edit
  def edit
  end

  # POST /available_values
  # POST /available_values.json
  def create
    @available_value = AvailableValue.new(available_value_params)

    respond_to do |format|
      if @available_value.save
        format.html { redirect_to @available_value, notice: 'Available value was successfully created.' }
        format.json { render :show, status: :created, location: @available_value }
      else
        format.html { render :new }
        format.json { render json: @available_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /available_values/1
  # PATCH/PUT /available_values/1.json
  def update
    respond_to do |format|
      if @available_value.update(available_value_params)
        format.html { redirect_to @available_value, notice: 'Available value was successfully updated.' }
        format.json { render :show, status: :ok, location: @available_value }
      else
        format.html { render :edit }
        format.json { render json: @available_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /available_values/1
  # DELETE /available_values/1.json
  def destroy
    @available_value.destroy
    respond_to do |format|
      format.html { redirect_to available_values_url, notice: 'Available value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_available_value
      @available_value = AvailableValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def available_value_params
      params.require(:available_value).permit(:name)
    end
end
