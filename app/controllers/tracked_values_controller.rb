class TrackedValuesController < ApplicationController
  before_action :set_tracked_value, only: [:show, :edit, :update, :destroy]

  # GET /tracked_values
  # GET /tracked_values.json
  def index
    @tracked_values = TrackedValue.all
  end

  # GET /tracked_values/1
  # GET /tracked_values/1.json
  def show
  end

  # GET /tracked_values/new
  def new
    @tracked_value = TrackedValue.new
  end

  # GET /tracked_values/1/edit
  def edit
  end

  # POST /tracked_values
  # POST /tracked_values.json
  def create
    @tracked_value = TrackedValue.new(tracked_value_params)

    respond_to do |format|
      if @tracked_value.save
        format.html { redirect_to @tracked_value, notice: 'Tracked value was successfully created.' }
        format.json { render :show, status: :created, location: @tracked_value }
      else
        format.html { render :new }
        format.json { render json: @tracked_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tracked_values/1
  # PATCH/PUT /tracked_values/1.json
  def update
    respond_to do |format|
      if @tracked_value.update(tracked_value_params)
        format.html { redirect_to @tracked_value, notice: 'Tracked value was successfully updated.' }
        format.json { render :show, status: :ok, location: @tracked_value }
      else
        format.html { render :edit }
        format.json { render json: @tracked_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracked_values/1
  # DELETE /tracked_values/1.json
  def destroy
    @tracked_value.destroy
    respond_to do |format|
      format.html { redirect_to tracked_values_url, notice: 'Tracked value was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tracked_value
      @tracked_value = TrackedValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tracked_value_params
      params.require(:tracked_value).permit(:user_id, :available_value_id)
    end
end
