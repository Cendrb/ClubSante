class ExerciseDaysController < ApplicationController
  before_action :set_exercise_day, only: [:show, :edit, :update, :destroy]

  # GET /exercise_days
  # GET /exercise_days.json
  def index
    @exercise_days = ExerciseDay.all
  end

  # GET /exercise_days/1
  # GET /exercise_days/1.json
  def show
  end

  # GET /exercise_days/new
  def new
    @exercise_day = ExerciseDay.new
  end

  # GET /exercise_days/1/edit
  def edit
  end

  # POST /exercise_days
  # POST /exercise_days.json
  def create
    @exercise_day = ExerciseDay.new(exercise_day_params)

    respond_to do |format|
      if @exercise_day.save
        format.html { redirect_to @exercise_day, notice: 'Exercise day was successfully created.' }
        format.json { render :show, status: :created, location: @exercise_day }
      else
        format.html { render :new }
        format.json { render json: @exercise_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_days/1
  # PATCH/PUT /exercise_days/1.json
  def update
    respond_to do |format|
      if @exercise_day.update(exercise_day_params)
        format.html { redirect_to @exercise_day, notice: 'Exercise day was successfully updated.' }
        format.json { render :show, status: :ok, location: @exercise_day }
      else
        format.html { render :edit }
        format.json { render json: @exercise_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_days/1
  # DELETE /exercise_days/1.json
  def destroy
    @exercise_day.destroy
    respond_to do |format|
      format.html { redirect_to exercise_days_url, notice: 'Exercise day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_day
      @exercise_day = ExerciseDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_day_params
      params.require(:exercise_day).permit(:date)
    end
end
