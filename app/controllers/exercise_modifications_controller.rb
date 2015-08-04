class ExerciseModificationsController < ApplicationController
  before_action :set_exercise_modification, only: [:show, :edit, :update, :destroy]

  # GET /exercise_modifications
  # GET /exercise_modifications.json
  def index
    @exercise_modifications = ExerciseModification.all
  end

  # GET /exercise_modifications/1
  # GET /exercise_modifications/1.json
  def show
  end

  # GET /exercise_modifications/new
  def new
    @exercise_modification = ExerciseModification.new
  end

  # GET /exercise_modifications/1/edit
  def edit
  end

  # POST /exercise_modifications
  # POST /exercise_modifications.json
  def create
    @exercise_modification = ExerciseModification.new(exercise_modification_params)

    respond_to do |format|
      if @exercise_modification.save
        format.html { redirect_to @exercise_modification, notice: 'Exercise modification was successfully created.' }
        format.json { render :show, status: :created, location: @exercise_modification }
      else
        format.html { render :new }
        format.json { render json: @exercise_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exercise_modifications/1
  # PATCH/PUT /exercise_modifications/1.json
  def update
    respond_to do |format|
      if @exercise_modification.update(exercise_modification_params)
        format.html { redirect_to @exercise_modification, notice: 'Exercise modification was successfully updated.' }
        format.json { render :show, status: :ok, location: @exercise_modification }
      else
        format.html { render :edit }
        format.json { render json: @exercise_modification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercise_modifications/1
  # DELETE /exercise_modifications/1.json
  def destroy
    @exercise_modification.destroy
    respond_to do |format|
      format.html { redirect_to exercise_modifications_url, notice: 'Exercise modification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exercise_modification
      @exercise_modification = ExerciseModification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_modification_params
      params.require(:exercise_modification).permit(:exercise_template_id, :date, :coach_id, :price, :note, :timetable_template_id)
    end
end
